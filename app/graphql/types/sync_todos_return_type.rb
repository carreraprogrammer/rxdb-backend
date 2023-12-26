module Types
  class SyncTodosReturnType < Types::BaseObject
    field :documents, [TodoType], null: false
    field :checkpoint, Types::CheckpointType, null: false
  end
end
