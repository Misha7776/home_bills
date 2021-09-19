class Properties::Forms::Create < BaseForm
  PERMITTED_ATTRIBUTES = %i[name address city notes user_id].freeze
  REQUIRED_ATTRIBUTES = %i[name address city user_id].freeze
  attr_accessor(*PERMITTED_ATTRIBUTES, :record)
end
