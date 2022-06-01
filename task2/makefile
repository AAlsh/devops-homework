# A simple makefile exposing basic commands to manage the container
build:
	docker-compose build
up: 
	docker-compose up -d
stop:
	docker-compose stop
start:
	docker-compose start
ps: 
	docker-compose ps
shell:
	docker-compose exec web /bin/sh
down:
	docker-compose down
destroy: 
	docker-compose down --rmi all
