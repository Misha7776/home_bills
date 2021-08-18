module Users
  module Forms
    class Update < BaseForm
      PERMITTED_ATTRIBUTES = %i[first_name last_name email password].freeze
      REQUIRED_ATTRIBUTES = %i[email password].freeze
      attr_accessor(*PERMITTED_ATTRIBUTES, :record)
    end
  end
end
