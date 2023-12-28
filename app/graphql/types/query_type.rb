# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :sync_todos, SyncTodosReturnType, null: false do
      argument :checkpoint, Types::CheckpointInputType, required: false
      argument :limit, Integer, required: false
    end
    
    field :todos, [TodoType], null: false

    field :checkpoint, Types::CheckpointType, null: false

    def todos
      Todo.all
    end

    def sync_todos(checkpoint: nil, limit: nil)
      if checkpoint
        min_id = checkpoint[:id]
        min_updated_at = checkpoint[:updated_at]
        query = Todo.where('updated_at > ? OR (updated_at = ? AND id > ?)', min_updated_at, min_updated_at, min_id)
      else
        query = Todo.all
      end

      todos_query = limit ? query.order(updated_at: :asc, id: :asc).limit(limit) : query.order(updated_at: :asc, id: :asc)

      {
        documents: todos_query,
        checkpoint: current_checkpoint
      }
    end

    # Método para obtener el último checkpoint
    def current_checkpoint
      last_todo = Todo.order(updated_at: :desc, id: :desc).first
      return {} unless last_todo

      {
        id: last_todo.id,
        updated_at: last_todo.updated_at.iso8601
      }
    end
  end
end
