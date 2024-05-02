# frozen_string_literal: true

class CreatePolicyService
  attr_reader :insured_person_attr, :vehicle_attr, :policy_attr

  def initialize(params)
    @insured_person_attr = params[:insured_person]
    @vehicle_attr = params[:vehicle]
    @policy_attr = params.slice(:effective_from, :effective_until).compact
  end

  def self.execute(params)
    new(params).execute
  end

  def execute
    return nil if policy_attr.keys.length != 2

    ActiveRecord::Base.transaction do
      insured_person = InsuredPerson.find_or_create_by(insured_person_attr)
      vehicle = Vehicle.find_or_create_by(vehicle_attr)

      raise ActiveRecord::Rollback if insured_person.id.nil? || vehicle.id.nil?

      policy = Policy.new(
        policy_attr.merge(
          insured_person_id: insured_person.id,
          vehicle_id: vehicle.id
        )
      )

      raise ActiveRecord::Rollback unless policy.save
      raise ActiveRecord::Rollback unless create_payment(policy.id)

      policy
    end
  end

  def create_payment(policy_id)
    Stripe::OneTimeChargeService.create_checkout(policy_id)
  end
end
