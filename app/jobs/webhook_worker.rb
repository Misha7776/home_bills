class WebhookWorker < ApplicationJob
  sidekiq_options retry: 10, dead: false
  sidekiq_retry_in do |retry_count|
    # Exponential backoff, with a random 30-second to 10-minute "jitter"
    # added in to help spread out any webhook "bursts."
    jitter = rand(30.seconds..10.minutes).to_i

    (retry_count**5) + jitter
  end

  def perform(webhook_event_id)
    WebhookEvents::Jobs::Send.call(webhook_event_id: webhook_event_id)
  end
end
