module WebhookEndpoints
  module Forms
    class Create < BaseForm
      PERMITTED_ATTRIBUTES = %i[url subscriptions enabled].freeze
      REQUIRED_ATTRIBUTES = %i[url subscriptions].freeze
      attr_accessor(*PERMITTED_ATTRIBUTES, :record)

      validate :subscriptions_length

      private

      def subscriptions_length
        errors.add(:subscriptions, 'should be at least 1 option') if subscriptions.length.zero?
      end
    end
  end
end
