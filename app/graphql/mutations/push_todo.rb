module Mutations
  class PushTodo < BaseMutation
    argument :write_rows, [Types::TodoInputPushType], required: true

    type [Types::TodoType]

    def resolve(write_rows:)
      conflicts = []

      write_rows.each do |row|
        assumed_master_state = row.assumedMasterState
        new_document_state = row.newDocumentState

        todo = Todo.find_by(id: new_document_state.id)

        if todo && conflict_detected?(todo, assumed_master_state)
          conflicts.push(todo)
        else
          todo ||= Todo.new(id: new_document_state.id)
          update_todo_attributes(todo, new_document_state)

          unless todo.save
            puts "Error saving Todo ID: #{todo.id}, Errors: #{todo.errors.full_messages}"
          end
        end
      end

      conflicts
    end

    private

    def conflict_detected?(todo, assumed_state)
      # assumed_state && todo.updated_at != assumed_state.updatedAt
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
