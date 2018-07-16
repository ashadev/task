class AddSentAtToVehicleTravelHistory < ActiveRecord::Migration[5.1]
  def change
  	add_column :vehicle_travel_histories, :sent_at, :datetime
  end
end
