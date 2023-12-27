module Types
  class MutationType < Types::BaseObject
    field :push_todo, mutation: Mutations::PushTodo
  end
end