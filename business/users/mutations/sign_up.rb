module Users
  module Mutations
    class SignUp < BaseMutation
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :email, String, required: true
      argument :password, String, required: true
      argument :password_confirmation, String, required: true

      field :token, String, null: true
      field :user, Types::UserType, null: true
      field :errors, [String], null: true

      def resolve(**record_params)
        @record_params = record_params
        build_record
        build_form
        return validation_fail unless form_valid?

        assign_attributes
        return validation_fail unless record.save

        { token: token, user: record }
      end

      private

      attr_reader :record

      def build_record
        @record = User.new(record_params)
      end

      def form_class
        Users::Forms::SignUp
      end

      def token
        Base64.encode64(record.email)
      end
    end
  end
end
