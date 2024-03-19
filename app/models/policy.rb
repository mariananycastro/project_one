class Policy < ApplicationRecord
  belongs_to :insured_person
  belongs_to :vehicle

  accepts_nested_attributes_for :insured_person, :vehicle

  validates :effective_from, :effective_until, presence: true
  validates :insured_person, :vehicle, presence: true
end
