class PaymentSerializer < ActiveModel::Serializer
  attributes :link, :status, :price
end
