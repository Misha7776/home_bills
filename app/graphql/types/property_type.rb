module Types
  class PropertyType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :address, String, null: true
    field :city, String, null: true
    field :notes, String, null: true
    field :user, Types::UserType, null: false
    field :user_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
