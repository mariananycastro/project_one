require 'sneakers'

Sneakers.configure(
  amqp: "amqp://guest:guest@rabbitmq:5672",
  heartbeat: 30,
  exchange: 'sneakers',
  exchange_type: 'direct'
)
