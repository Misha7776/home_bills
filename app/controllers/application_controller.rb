class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def current_user
    token = request.headers['Authorization']&.split&.last
    return if token.blank?

    email = Base64.decode64(token)
    User.find_by(email: email)
  end
end
