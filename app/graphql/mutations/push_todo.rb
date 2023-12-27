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

        # Si assumed_master_state es nil, significa que es una tarea nueva o una actualización sin gestión de conflictos.
        if assumed_master_state.nil? || todo.new_record?
          # Asigna los nuevos atributos al Todo.
          update_todo_attributes(todo, new_document_state)

          if todo.save
            updated_todos << todo
          else
            puts "Error saving Todo ID: #{todo.id}, Errors: #{todo.errors.full_messages}"
          end
        else
          puts "Skipping update for Todo ID: #{todo.id} due to potential conflict"
        end
      end

      { todos: updated_todos }
    end

    private

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
