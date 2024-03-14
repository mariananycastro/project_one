class AddVehicleRefToPolicy < ActiveRecord::Migration[7.0]
  def change
    add_reference :policies, :vehicle, null: false, foreign_key: true
  end
end
