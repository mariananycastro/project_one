class Policy < ApplicationRecord
  belongs_to :insured_person
  belongs_to :vehicle

  accepts_nested_attributes_for :insured_person, :vehicle

  validates :effective_from, :effective_until, presence: true
  validates :insured_person, :vehicle, presence: true
  validate :vehicle_policy_uniquess

  def vehicle_policy_uniquess
    if vehicle && Policy.joins(:vehicle).where(vehicles:{license_plate: vehicle.license_plate}).exists?
      errors.add(:base, "Vehicle already has policy")
    end
  end
end
