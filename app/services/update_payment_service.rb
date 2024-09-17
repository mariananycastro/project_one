# frozen_string_literal: true

class UpdatePaymentService
  class InvalidPaymentUpdateError < StandardError; end

  attr_reader :payment_id, :status, :payment_status

  def initialize(params)
    @payment_id = params[:id]
    @payment_status = params[:payment_status] # unpaid / paid
    @status = params[:status] # expired / complete
  end

  def self.execute(params)
    new(params).execute
  end

  def execute
    ActiveRecord::Base.transaction do
      payment = Payment.find_by(external_id: payment_id)
      policy = payment&.policy

      raise InvalidPaymentUpdateError, "Error to update payment #{ payment_id }" unless payment || policy

      if payment_status == 'paid'
        payment.update!(status: 'paid')
        policy.update!(status: 'active')
      elsif status == 'expired'
        payment.update!(status: 'expired')
        policy.update!(status: 'canceled')
      end

      websocket_broadcast(policy)
    end
  end

  def websocket_broadcast(policy)
    url = ENV['SINATRA_BROADCAST_URL']
    message = {
      license_plate: policy.vehicle.license_plate,
      email: policy.insured_person.email,
      policy_status: policy.status,
      payment_status: policy.payment.status
    }

    WebsocketConnectionService.broadcast(url, message)
  end
end
