.PHONY: build up down test dev-shell test-shell

build:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml build

up: down
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -- build

down:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down -v

dev-shell:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml run app sh

test-shell:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml  run  --service-ports app  sh

test:
	docker-compose -f docker-compose.yml -f docker-compose.test.yml run --service-ports app  sh  -c "mix test"
