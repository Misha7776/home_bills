module Users
  module Forms
    class SignUp < BaseForm
      PERMITTED_ATTRIBUTES = %i[first_name last_name email password password_confirmation].freeze
      REQUIRED_ATTRIBUTES = %i[email password password_confirmation].freeze
      attr_accessor(*PERMITTED_ATTRIBUTES, :record)
    end
  end
end
