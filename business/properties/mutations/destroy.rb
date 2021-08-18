module Properties
  module Mutations
    class Destroy < BaseMutation
      argument :id, Integer, required: true

      field :property, Types::PropertyType, null: true
      field :errors, [String], null: false

      def resolve(id:)
        raise_unauthenticated if current_user.nil?
        find_record(id)

        if record.destroy
          { property: record }
        else
          { errors: record.errors.full_messages }
        end
      end

      private

      attr_reader :record

      def raise_unauthenticated
        raise GraphQL::ExecutionError, 'You need to authenticate to perform this action'
      end

      def find_record(id)
        @record = current_user.properties.find(id)
      end

      def assign_attributes(attributes)
        record.assign_attributes(attributes)
      end
    end
  end
end
