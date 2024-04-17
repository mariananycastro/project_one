class InsuredPerson < ApplicationRecord
  has_many :policies
  
  validates :name, :document, :email, presence: true  
  validates :document, :email, uniqueness: true
end
