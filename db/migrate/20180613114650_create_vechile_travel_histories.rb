class CreateVechileTravelHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicle_travel_histories do |t|
      t.integer :vehicle_id
      t.string :latitude
      t.string :longitude
      t.string :speed
      t.boolean :digital_ip_op
      t.boolean :external_power_status
      t.string :analog_ip1
      t.string :analog_ip2

      t.timestamps
    end
  end
end
