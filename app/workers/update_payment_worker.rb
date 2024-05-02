# frozen_string_literal: true

class UpdatePaymentWorker
  include Sneakers::Worker
  QUEUE_NAME = 'update-payment'

  from_queue QUEUE_NAME

  def work(msg)
    ActiveRecord::Base.connection_pool.with_connection do
      attr = JSON.parse(msg).with_indifferent_access

      Rails.logger.tagged("Update payment worker #{attr[:id]}") do |logger|
        result = UpdatePaymentService.execute(attr)

        return ack! if result

        reject!
      end
    end
  end
end
