class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :text
      t.boolean :is_completed
      t.boolean :deleted

      t.timestamps
    end
  end
end
