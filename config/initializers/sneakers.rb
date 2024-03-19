require 'sneakers'

Sneakers.configure(
  connection: Bunny.new(
    hostname: 'rabbitmq'
  ),
  heartbeat: 30,
  exchange: 'sneakers',
  exchange_type: 'direct'
)
