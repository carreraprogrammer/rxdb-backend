module Types
  class QueryType < Types::BaseObject
    field :sync_todos, SyncTodosReturnType, null: false do
      argument :checkpoint, Types::CheckpointInputType, required: false
      argument :limit, Integer, required: false
    end
    
    field :todos, [TodoType], null: false

    def todos
      Todo.all
    end

    def sync_todos(checkpoint: nil, limit: nil)
      min_id = checkpoint ? checkpoint[:id] : nil
      min_updated_at = checkpoint ? checkpoint[:updated_at] : nil

      query = if checkpoint
                Todo.where('updated_at > ? OR (updated_at = ? AND id > ?)', min_updated_at, min_updated_at, min_id)
              else
                Todo.all
              end

      todos_query = limit ? query.order(updated_at: :asc, id: :asc).limit(limit) : query.order(updated_at: :asc, id: :asc)
      last_todo = todos_query.last

      new_checkpoint = if last_todo
                         { id: last_todo.id, updated_at: last_todo.updated_at.iso8601 }
                       else
                         checkpoint ? { id: min_id, updated_at: min_updated_at } : nil
                       end

      {
        documents: todos_query,
        checkpoint: new_checkpoint
      }
    end
  end
end
