module Api
  module V1
    class BaseController < ApplicationController
      include Serialization
      skip_before_action :authenticate_user!

      def current_user
        token = request.headers['Authorization']&.split&.last
        return if token.blank?

        email = Base64.decode64(token)
        User.find_by(email: email)
      end
    end
  end
end
