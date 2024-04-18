class VehicleSerializer < ActiveModel::Serializer
  attributes :brand, :vehicle_model, :year, :license_plate
end
