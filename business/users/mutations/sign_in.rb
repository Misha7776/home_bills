module Users
  module Mutations
    class SignIn < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(email:, password:)
        return credentials_invalid if find_record(email).blank?
        return credentials_invalid unless record.valid_password?(password)

        successful_response
      end

      private

      attr_reader :record

      def find_record(email)
        @record = User.find_by!(email: email)
      end

      def token
        Base64.encode64(record.email)
      end

      def successful_response
        { token: token, user: record }
      end

      def credentials_invalid
        { errors: ['Invalid password or email'] }
      end
    end
  end
end
