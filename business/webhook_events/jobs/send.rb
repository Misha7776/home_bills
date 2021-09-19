module WebhookEvents
  module Jobs
    class Send < BaseAction
      def call
        within_rescue do
          find_webhook_event
          return if webhook_event.blank?

          @webhook_endpoint = webhook_event.webhook_endpoint
          return if @webhook_endpoint.blank?
          return unless webhook_endpoint_valid?

          send_webhook
          handle_failed_request
        end
      end

      private

      attr_reader :webhook_event, :webhook_event_id, :response, :webhook_endpoint

      def find_webhook_event
        @webhook_event = WebhookEvent.find_by(id: webhook_event_id)
      end

      def webhook_endpoint_valid?
        webhook_endpoint.subscribed?(webhook_event.event) && webhook_endpoint.enabled?
      end

      def send_webhook
        # Send the webhook request with a 30 second timeout.
        @response = Faraday.post(webhook_endpoint.url) do |req|
          req.headers = webhook_headers
          req.body = webhook_body
          req.options.timeout = 30
        end
      end

      def webhook_headers
        {
          'User-Agent' => 'rails_webhook_system/1.0',
          'Content-Type' => 'application/json'
        }
      end

      def webhook_body
        {
          event: webhook_event.event,
          payload: webhook_event.payload
        }.to_json
      end

      def handle_failed_request
        store_webhook_response
        case webhook_event
        in webhook_endpoint: { url: /\.ngrok\.io/ }, response: { code: 404, body: /tunnel .+?\.ngrok\.io not found/i }
          log('Deleting dead ngrok endpoint', response.status)
          # Automatically delete dead ngrok tunnel endpoints. This error likely
          # means that the developer forgot to remove their temporary ngrok
          # webhook endpoint, seeing as it no longer exists.
          webhook_endpoint.destroy!
        in webhook_endpoint: { url: /\.ngrok\.io/ }, response: { code: 502 }
          log(' Retrying unresponsive ngrok endpoint', response.status)
          # The bad gateway error usually means that the tunnel is still open
          # but the local server is no longer responding for any number of
          # reasons. We're going to automatically retry.
          raise FailedRequestError
        in webhook_endpoint: { url: /\.ngrok\.io/ }, response: { code: 504 }
          log('Disabling bad ngrok endpoint', response.status)
          # Automatically disable these since the endpoint is likely an ngrok
          # "stable" URL, but it's not currently running. To save bandwidth,
          # we do not want to automatically retry.
          webhook_endpoint.disable!
        else
          log('Failed webhook event', response.status)
          # Raise a failed request error and let Sidekiq handle retrying.
          raise FailedRequestError
        end
      end

      def within_rescue
        yield
      rescue HTTP::TimeoutError
        error = 'TIME_OUT_ERROR'
        log('Timeout for webhook event', error)
        # This error means the webhook endpoint timed out. We can either
        # raise a failed request error to trigger a retry, or leave it
        # as-is and consider timeouts terminal. We'll do the latter.
        webhook_event.update(response: { error: error })
      rescue OpenSSL::SSL::SSLError
        error = 'TLS_ERROR'
        log('TLS error for webhook event', error)
        # Since TLS issues may be due to an expired cert, we'll continue retrying
        # since the issue may get resolved within the 3 day retry window. This
        # may be a good place to send an alert to the endpoint owner.
        webhook_event.update(response: { error: error })
        # Signal the webhook for retry.
        raise FailedRequestError
      rescue HTTP::ConnectionError
        error = 'CONNECTION_ERROR'
        log('Connection error for webhook event', error)
        # This error usually means DNS issues. To save us the bandwidth,
        # we're going to disable the endpoint. This would also be a good
        # location to send an alert to the endpoint owner.
        webhook_event.update(response: { error: error })

        # Disable the problem endpoint.
        webhook_endpoint.disable!
      end

      def store_webhook_response
        # Store the webhook response.
        webhook_event.update(response: {
                               headers: response.headers.to_h,
                               code: response.status.to_i,
                               body: response.body.to_s
                             })
      end

      def logger
        Sidekiq.logger
      end

      def log(message, error)
        logger.warn "[webhook_worker] #{message}: type=#{webhook_event.event}
                              event=#{webhook_event.id}
                              endpoint=#{webhook_endpoint.id}
                              url=#{webhook_endpoint.url} code=#{error}"
      end
    end
  end
end
