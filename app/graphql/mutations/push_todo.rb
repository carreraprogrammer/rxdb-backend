# mutations/push_todo.rb
module Mutations
  class PushTodo < BaseMutation
    argument :write_rows, [Types::TodoInputPushType], required: true
    field :todos, [Types::TodoType], null: false

    def resolve(write_rows:)
      updated_todos = []

      write_rows.each do |row|
        # Extrae los estados asumido y nuevo del documento.
        assumed_master_state = row.assumedMasterState
        new_document_state = row.newDocumentState

        todo = Todo.find_or_initialize_by(id: new_document_state.id)

        # Procesa solo si no hay conflicto o si assumed_master_state es nil
        if assumed_master_state.nil? || !conflict_detected?(todo, assumed_master_state)
          # Asigna los nuevos atributos al Todo.
          update_todo_attributes(todo, new_document_state)

          if todo.save
            updated_todos << todo
          else
            puts "Error saving Todo ID: #{todo.id}, Errors: #{todo.errors.full_messages}"
          end
        else
          puts "Conflict detected for Todo ID: #{todo.id}"
        end
      end

      { todos: updated_todos }
    end

    private

    # Método para detectar conflictos
    def conflict_detected?(todo, assumed_master_state)
      return false unless todo.persisted?

      db_updated_at = todo.updated_at.utc.iso8601
      input_updated_at = assumed_master_state.updatedAt.utc.iso8601

      db_updated_at != input_updated_at
    end

    # Método para actualizar los atributos de Todo
    def update_todo_attributes(todo, new_document_state)
      todo.assign_attributes(
        text: new_document_state.text,
        is_completed: new_document_state.isCompleted,
        deleted: new_document_state.deleted
      )
    end
  end
end
