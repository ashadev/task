class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.integer :operation
      t.integer :status, default: 0
      t.text :reason

      t.timestamps
    end
  end
end
