module Types
  class MutationType < Types::BaseObject
    # Users
    field :sign_in, mutation: Users::Mutations::SignIn
    field :sign_up, mutation: Users::Mutations::SignUp
    # field :update_user, mutation: Users::Mutations::Update

    # Properties
    field :create_property, mutation: Properties::Mutations::Create
    field :update_property, mutation: Properties::Mutations::Update
    field :destroy_property, mutation: Properties::Mutations::Destroy
  end
end
