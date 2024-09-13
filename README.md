# README
This is the first in a series of projects created by Rebase to help me study many tools, gems, etc.

This project will help me study:
- Docker
- PostgreSQL
- RabbitMQ

## Main Object
In this project we will create a routes to get the policy which will be used by project_two with Graphql
add route

There will be a (worker)[path] which will create a new policy.
add payload and queue

## Ruby version 3.3.0

## Docker
This project uses Docker which has 3 containers: postgres, app and sneakers.

To run all container with the command below found in [Makefile](Makefile).

```make bash```

To stop all containers run:

```make down```

## Database
The database uses **PostgreSQL**, and has only 3 tables.

- Insured People with name and document.
- Vehicle with brand, vehicle_model, year, license_plate.
- Policy with effective_from, effective_until, insured_person and vehicle.

## Message Broker
We used **RabbitMQ**, and **Sneakers** to help with the workers creation and setups.
The container **sneakers** needs to be up to allow the comunication with rabbit. It has the same setup and volume as the container app, but runs in the local port 3001, and runs the command below which allows the application to keep listening to all queues what workers inside the folder app/workers listen.

```rake sneakers:run```

The container **rabbit** should also be running.
You can run it using the command below found in [Makefile](Makefile).

```make rabbit```

To stop the rabbit container run:

```make stop container_name=rabbitmq```

When the rabbit container is running you can check connections, channels, queues, streams and setting in:

```http://localhost:15672```

username: guest
password: guest

### Links
#### Rabbit
https://www.rabbitmq.com/tutorials/tutorial-one-ruby

https://www.rabbitmq.com/docs

#### Sneakers
https://github.com/jondot/sneakers

https://github.com/jondot/sneakers/wiki

## Setup
TODO
