# frozen_string_literal: true

class CreatePolicyWorker
  include Sneakers::Worker
  from_queue 'create_policy'

  def work(msg)
    logger.info "Creating policy worker #{msg}"
  end
end
