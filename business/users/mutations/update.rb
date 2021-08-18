module Users
  module Mutations
    class Update
      # argument :email, String, required: true
      # argument :password, String, required: true
      # argument :first_name, String, required: true
      # argument :last_name, String, required: true
      #
      # field :user, Types::UserType, null: true
      # field :errors, [String], null: false
      #
      # def resolve(**record_params)
      #   binding.pry
      #   @record_params = record_params
      #   build_record
      #   build_form
      #   return validation_fail unless form_valid?
      #
      #   assign_attributes
      #   return validation_fail unless save_record
      #
      #   { user: user }
      # end
      #
      # private
      #
      # attr_reader :record
      #
      # def build_record
      #   @record = User.new(record_params)
      # end
      #
      # def form_class
      #   Users::Forms::Update
      # end
    end
  end
end