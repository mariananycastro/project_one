class PolicySerializer < ActiveModel::Serializer
  attributes :effective_from, :effective_until
  has_one :insured_person, serializer: InsuredPersonSerializer
  has_one :vehicle, serializer: VehicleSerializer
  has_one :payment, serializer: PaymentSerializer
end
