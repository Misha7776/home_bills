module Types
  class MutationType < Types::BaseObject
    field :sign_in, mutation: Mutations::Users::SignInMutation

    # Properties
    field :create_property, mutation: Mutations::Properties::Create
    field :update_property, mutation: Mutations::Properties::Update
    field :destroy_property, mutation: Mutations::Properties::Destroy
  end
end
