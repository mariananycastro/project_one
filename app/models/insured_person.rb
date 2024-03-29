class InsuredPerson < ApplicationRecord
  has_many :policies
  
  validates :name, :document, presence: true  
  validates :document, uniqueness: true
end
