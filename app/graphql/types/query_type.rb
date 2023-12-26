# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Usamos SyncTodosReturnType para el campo sync_todos
    field :sync_todos, SyncTodosReturnType, null: false do
      argument :checkpoint, Types::CheckpointInputType, required: false
      argument :limit, Integer, required: false
    end

    # Este campo parece no ser necesario dado el nuevo diseño, podrías considerar removerlo
    # field :documents, [TodoType], null: false

    # Mantenemos el campo todos como estaba
    field :todos, [TodoType], null: false

    # Campo checkpoint
    field :checkpoint, Types::CheckpointType, null: false

    # Método para obtener todos los todos
    def todos
      Todo.all
    end

    # Método para la sincronización de todos
    def sync_todos(checkpoint: nil, limit: nil)
      if checkpoint
        min_id = checkpoint[:id]
        min_updated_at = checkpoint[:updated_at]
        query = Todo.where('updated_at > ? OR (updated_at = ? AND id > ?)', min_updated_at, min_updated_at, min_id)
      else
        query = Todo.all
      end

      todos_query = limit ? query.order(updated_at: :asc, id: :asc).limit(limit) : query.order(updated_at: :asc, id: :asc)

      # Devolvemos un hash con las claves documents y checkpoint
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
