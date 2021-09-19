module WebhookEndpoints
  module Operations
    class Destroy < BaseOperation
      def call
        delete_record
        assign_args
        success(args)
      end

      private

      def delete_record
        args[:record] = record
        @record = record.destroy
      end

      def assign_args
        args[:record] = @record
      end
    end
  end
end