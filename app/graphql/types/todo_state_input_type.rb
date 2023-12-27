module Types
  class TodoStateInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :text, String, required: true
    argument :isCompleted, Boolean, required: true
    argument :deleted, Boolean, required: true
    argument :updatedAt, GraphQL::Types::ISO8601DateTime, required: true
    argument :createdAt, GraphQL::Types::ISO8601DateTime, required: false
  end
end