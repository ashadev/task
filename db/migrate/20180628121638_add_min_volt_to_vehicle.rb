class AddMinVoltToVehicle < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :minimum_voltage, :string
    add_column :vehicles, :maximum_voltage, :string
    add_column :vehicles, :threshold_voltage, :string
  end
end
