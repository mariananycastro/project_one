class ChangeVehicle < ActiveRecord::Migration[7.0]
  def change
    add_index :vehicles, :license_plate, unique: true
  end
end
