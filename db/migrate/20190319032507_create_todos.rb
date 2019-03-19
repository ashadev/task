class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.string :title
      t.integer :kind
      t.text :description
      t.date :due_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
