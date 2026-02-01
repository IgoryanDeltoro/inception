all: setup up

setup:
	sudo mkdir -p /home/$(USER)/data/wordpress
	sudo mkdir -p /home/$(USER)/data/mariadb
	sudo chown -R $(USER):$(USER) /home/$(USER)/data


up:
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down


# instead ID gonna be name of container
inspect:
	docker inspect ${ID}

exec:
	docker exec -it ${ID} /bin/bash

ps:
	docker ps	


clean: down 
	docker compose -f ./srcs/docker-compose.yml down -v
	docker system prune -f

re: clean setup
	docker compose -f ./srcs/docker-compose.yml build --no-cache
	docker compose -f ./srcs/docker-compose.yml up -d