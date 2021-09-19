module WebhookEndpoints
  module Operations
    class Update < BaseOperation
      def call
        build_form
        return validation_fail unless form_valid?

        assign_attributes
        return validation_fail unless save_record

        assign_args
        success(args)
      end

      private

      def assign_args
        args[:record] = @record
      end

      def form_class
        WebhookEndpoints::Forms::Update
      end
    end
  end
end