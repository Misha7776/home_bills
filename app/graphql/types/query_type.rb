module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :properties, [Types::PropertyType], null: false, description: 'Returns a list of properties'
    field :users, [Types::UserType], null: false, description: 'Return a list of all users'
    field :me, Types::UserType, null: false

    def properties
      Property.preload(:user)
    end

    def users
      User.all
    end

    def me
      context[:current_user]
    end
  end
end
