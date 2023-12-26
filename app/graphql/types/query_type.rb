# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Query para obtener todos los todos
    field :todos, [TodoType], null: false

    def todos
      Todo.all
    end
  end
end
