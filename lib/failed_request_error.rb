# General failed request error that we're going to use to signal
# Sidekiq to retry our webhook worker.
class FailedRequestError < StandardError; end