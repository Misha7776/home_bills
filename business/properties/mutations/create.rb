module Properties
  module Mutations
    class Create < BaseMutation
      # argument :user_id, Integer, required: true
      argument :name, String, required: true
      argument :address, String, required: false
      argument :city, String, required: false
      argument :notes, String, required: false

      field :property, Types::PropertyType, null: true
      field :errors, [String], null: true

      def resolve(**attributes)
        raise_unauthenticated if current_user.nil?
        property = current_user.properties.build(attributes)

        if property.save
          { property: property }
        else
          { errors: property.errors.full_messages }
        end
      end

      private

      def raise_unauthenticated
        raise GraphQL::ExecutionError, 'You need to authenticate to perform this action'
      end
    end
  end
end
