build:
	@docker-compose build

bash:
	@docker-compose run --rm --service-ports app bash

server: # make server port=3000
	@docker-compose run --rm -p ${port}:${port} app \
		sh -c "bundle exec rails server -p ${port} -b 0.0.0.0"
