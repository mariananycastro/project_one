build:
	@docker-compose build

bash:
	docker compose up -d
	docker exec -it app bash

rabbit:
	@docker run --rm -p 15672:15672 -p 5672:5672 --name rabbitmq --network initiatives rabbitmq:3-management

down:
	@docker compose down

stop: # make stop container=rabbitmq
	docker stop ${container}

server:
	docker compose up -d
	docker exec -it app /bin/sh -c "bin/setup \
		&& bundle exec rails server --binding 0.0.0.0 -p 3000"

sneakers:
	docker logs --follow sneakers
