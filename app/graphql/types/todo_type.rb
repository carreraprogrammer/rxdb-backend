module Types
  class TodoType < Types::BaseObject
    field :id, ID, null: false
    field :text, String, null: true
    field :isCompleted, Boolean, null: true, method: :is_completed
    field :deleted, Boolean, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end