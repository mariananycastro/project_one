class PaymentSerializer < ActiveModel::Serializer
  attributes :link, :status, :price, :external_id
end
