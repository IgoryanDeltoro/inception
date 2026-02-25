# VARIABLES                                     
# Docker compose file shortcut
COMPOSE = docker compose -f ./srcs/docker-compose.yml

# Data directory on host (required by Inception subject)
DATA_PATH = /home/$(USER)/data

# MAIN TARGET                                   
# Default target
all: up

# SETUP                                         
# Create required host directories for bind mounts
setup:
	@echo "Creating data directories..."
	sudo mkdir -p $(DATA_PATH)/wordpress
	sudo mkdir -p $(DATA_PATH)/mariadb
	sudo chown -R $(USER):$(USER) $(DATA_PATH)


# DOCKER CONTROL                                
# Build images and start containers
up: setup
	$(COMPOSE) up -d

# Stop and remove containers + network
down:
	$(COMPOSE) down

# Stop containers only
stop:
	$(COMPOSE) stop

# Start existing containers
start:
	$(COMPOSE) start

# Restart containers
restart: down up

# Full rebuild (no cache)
rebuild: clean setup
	$(COMPOSE) build --no-cache
	$(COMPOSE) up -d

# Recreate everything from scratch
re: fclean all


# DEBUGGING                                     
# List volumes
vl:
	docker volume ls

# Inspect specific project volumes
volumes:
	docker volume inspect $$(docker volume ls -q | grep -E "(wp_data|db_data)")

# Test network resolution (WordPress → MariaDB)
vnres:
	docker exec -it wordpress ping mariadb

# Check WordPress database connection
dconn:
	docker exec -it wordpress sudo -u www-data wp db check

# Execute into specific container
exec:
	docker exec -it ${ID} /bin/bash

# Show container status
status:
	docker ps -a

# Show logs
logs:
	$(COMPOSE) logs


# CLEANING                                      
# Remove containers and unused Docker resources
clean: down
	$(COMPOSE) down -v
	docker system prune -f

# Remove everything including volumes and host data
fclean: clean
	docker system prune -a
	sudo rm -rf $(DATA_PATH)/wordpress
	sudo rm -rf $(DATA_PATH)/mariadb


.PHONY: all setup setup_ping up down stop start restart rebuild re \
        vl volumes vnres dconn exec status logs clean fclean
