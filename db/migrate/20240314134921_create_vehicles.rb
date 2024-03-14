class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :brand
      t.string :vehicle_model
      t.integer :year
      t.string :license_plate

      t.timestamps
    end
  end
end
