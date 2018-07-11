class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :vehicle_name
      t.string :device_id
      t.string :vehicle_number
      t.text :description
      t.boolean :is_active, default: true
      t.integer :company_id

      t.timestamps
    end
  end
end
