module Types
  class CheckpointType < Types::BaseObject
    field :id, String, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end