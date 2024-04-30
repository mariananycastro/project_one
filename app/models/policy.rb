class Policy < ApplicationRecord
  belongs_to :insured_person
  belongs_to :vehicle
  has_one :payment

  enum status: { draft: 0, active: 1, expired: 2, canceled: 3, pending: 4 }

  accepts_nested_attributes_for :insured_person, :vehicle

  validates :effective_from, :effective_until, presence: true
  validates :insured_person, :vehicle, presence: true
  validate :vehicle_policy_uniquess

  def vehicle_policy_uniquess
    if vehicle && Policy.joins(:vehicle).where(vehicles:{license_plate: vehicle.license_plate}).exists?
      errors.add(:base, "Vehicle already has policy")
    end
  end

  scope :by_email, lambda { |email|
    joins(:insured_person).where(insured_people: { email: email })
  }
end
