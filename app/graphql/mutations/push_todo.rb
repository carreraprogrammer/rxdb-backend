module Mutations
  class PushTodo < BaseMutation
    argument :write_rows, [Types::TodoInputPushType], required: true
    field :todos, [Types::TodoType], null: false
    field :conflicts, [Types::TodoType], null: false

    def resolve(write_rows:)
      updated_todos = []
      conflicts = []

      write_rows.each do |row|
        # Extrae los estados asumido y nuevo del documento.
        assumed_master_state = row.assumedMasterState
        new_document_state = row.newDocumentState

        todo = Todo.find_by(id: new_document_state.id)

        # Verifica si hay conflictos.
        if todo && conflict_detected?(todo, assumed_master_state)
          conflicts.push(todo)
        else
          todo = Todo.new(id: new_document_state.id) unless todo
          update_todo_attributes(todo, new_document_state)

          if todo.save
            updated_todos << todo
          else
            puts "Error saving Todo ID: #{todo.id}, Errors: #{todo.errors.full_messages}"
          end
        end
      end

      puts "Actualizados: #{updated_todos.map(&:id)}"
      puts "Conflictos: #{conflicts.map(&:id)}"

      { conflicts: conflicts, todos: updated_todos }
    end

    private

    def conflict_detected?(todo, assumed_state)
      return false if assumed_state.nil?

      todo.updatedAt != assumed_state.updatedAt
    end

    def update_todo_attributes(todo, new_document_state)
      todo.assign_attributes(
        text: new_document_state.text,
        is_completed: new_document_state.isCompleted,
        deleted: new_document_state.deleted,
        updated_at: new_document_state.updatedAt
      )
    end
  end
end
