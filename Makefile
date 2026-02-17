COMPOSE = docker compose -f ./srcs/docker-compose.yml

all: up

setup:
	sudo mkdir -p /home/$(USER)/data/wordpress
	sudo mkdir -p /home/$(USER)/data/mariadb
	sudo chown -R $(USER):$(USER) /home/$(USER)/data

up: setup
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart: down up

re: fclean all

rebuild: clean setup
	$(COMPOSE) build --no-cache
	$(COMPOSE) up -d

inspect:
	docker inspect ${ID}

exec:
	docker exec -it ${ID} /bin/bash

status:
	docker ps -a

logs:
	$(COMPOSE) logs -f

clean: down
	docker system prune -f

fclean: clean
	$(COMPOSE) down -v
	sudo rm -rf /home/$(USER)/data/wordpress
	sudo rm -rf /home/$(USER)/data/mariadb

.PHONY: all setup up down stop start restart rebuild inspect exec status logs clean fclean
