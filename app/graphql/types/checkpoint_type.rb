module Types
  class CheckpointType < Types::BaseObject
    field :id, String, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end