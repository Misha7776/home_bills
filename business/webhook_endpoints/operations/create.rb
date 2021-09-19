module WebhookEndpoints
  module Operations
    class Create < BaseOperation
      def call
        build_record
        build_form
        return validation_fail unless form_valid?
        return validation_fail unless save_record

        assign_args
        success(args)
      end

      private

      def build_record
        @record = WebhookEndpoint.new(record_params)
      end

      def assign_args
        args[:record] = @record
      end

      def form_class
        WebhookEndpoints::Forms::Create
      end
    end
  end
end