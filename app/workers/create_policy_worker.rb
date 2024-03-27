# frozen_string_literal: true

class CreatePolicyWorker
  include Sneakers::Worker
  QUEUE_NAME = 'create-policy'

  from_queue QUEUE_NAME

  def work(msg)
    ActiveRecord::Base.connection_pool.with_connection do
      attr = JSON.parse(msg).with_indifferent_access

      Rails.logger.tagged("Creating policy worker #{attr[:insured_person][:document]}") do |logger|
        new_policy = CreatePolicyService.execute(attr)
        logger.info new_policy

        return ack! if new_policy

        reject!
      end
    end
  end
end
