class Vehicle < ApplicationRecord
  has_many :policies

  validates :brand, :vehicle_model, :year, :license_plate, presence: true  
  validates :license_plate, uniqueness: true
end
