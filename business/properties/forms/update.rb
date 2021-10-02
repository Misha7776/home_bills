class Properties::Forms::Update < BaseForm
  PERMITTED_ATTRIBUTES = %i[name address city notes photo].freeze
  REQUIRED_ATTRIBUTES = %i[name address city].freeze
  attr_accessor(*PERMITTED_ATTRIBUTES, :record)
end
