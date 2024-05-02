class Payment < ApplicationRecord
  belongs_to :policy

  enum status: { pending: 0, paid: 1, failed: 2, expired: 3 }
end
