module Types
  class CheckpointInputType < Types::BaseInputObject
    argument :id, String, required: false
    argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
  end
end