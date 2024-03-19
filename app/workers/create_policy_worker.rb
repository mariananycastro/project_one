# frozen_string_literal: true

class CreatePolicyWorker
  include Sneakers::Worker
  from_queue 'testing'

  def work(msg)
    logger.info "hello #{msg}"
  end
end
