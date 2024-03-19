build:
	@docker-compose build

bash:
	docker compose up -d
	docker exec -it app bash

rabbit:
	@docker run --rm -p 15672:15672 -p 5672:5672 --name rabbitmq --network project-one_default rabbitmq:3-management

down:
	@docker compose down

stop: # make stop container_name=rabbitmq
	docker stop ${container_name}

server:
	docker compose up -d
	docker exec -it app /bin/sh -c "bin/setup \
		&& bundle exec rails server --binding 0.0.0.0"

sneakers:
	docker logs --follow sneakers
