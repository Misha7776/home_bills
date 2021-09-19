module WebhookEvents
  module Actions
    class Broadcast < BaseAction
      def call
        WebhookEndpoint.enabled.find_each do |webhook_endpoint|
          next unless webhook_endpoint.subscribed?(event)

          webhook_event = create_webhook_event(webhook_endpoint)
          send_webhook(webhook_event)
        end
      end

      private

      attr_reader :event, :payload

      def send_webhook(webhook_event)
        WebhookWorker.perform_later(webhook_event.id)
      end

      def create_webhook_event(webhook_endpoint)
        WebhookEvent.create!(webhook_endpoint: webhook_endpoint,
                             event: event, payload: payload)
      end
    end
  end
end
