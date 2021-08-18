module Users
  module Mutations
    class SignIn < BaseMutation
      argument :email, String, required: true
      argument :password, String, required: true

      field :token, String, null: true
      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(email:, password:)
        return credentials_invalid if find_user(email).blank?
        return credentials_invalid unless user.valid_password?(password)

        successful_response
      end

      private

      attr_reader :user

      def find_user(email)
        @user = User.find_by!(email: email)
      end

      def token
        Base64.encode64(user.email)
      end

      def successful_response
        { token: token, user: user }
      end

      def credentials_invalid
        { errors: ['Invalid password or email'] }
      end
    end
  end
end
