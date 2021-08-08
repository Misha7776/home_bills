module Mutations
  module Properties
    class Update < Mutations::BaseMutation
      argument :id, Integer, required: true
      argument :name, String, required: true
      argument :address, String, required: false
      argument :city, String, required: false
      argument :notes, String, required: false

      field :property, Types::PropertyType, null: true
      field :errors, [String], null: false

      def resolve(id:, **attributes)
        raise_unauthenticated if current_user.nil?
        find_record(id)
        assign_attributes(attributes)

        if record.save
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
