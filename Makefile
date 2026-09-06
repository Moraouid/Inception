COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data

all:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@echo "Building Inception infrastructure..."
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "Shutting down containers..."
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) ps --all

up:
	@echo "Starting containers..."
	docker compose -f $(COMPOSE_FILE) up -d

ps:
	@echo "Displaying container status..."
	docker compose -f $(COMPOSE_FILE) ps --all

images:
	@echo "Displaying images..."
	docker compose -f $(COMPOSE_FILE) images

logs:
	@echo "Displaying logs..."
	docker compose -f $(COMPOSE_FILE) logs

shell:
	@if [ -z "$(s)" ]; then echo "Usage: make shell s=<service>"; exit 1; fi
	docker compose -f $(COMPOSE_FILE) exec $(s) bash

clean:
	@echo "Stopping and removing containers, networks, and images..."
	docker compose -f $(COMPOSE_FILE) down --rmi all -v

fclean: clean
	@echo "Deep cleaning local volumes and Docker system..."
	@sudo rm -rf $(DATA_DIR)
	docker system prune -af --volumes

re: fclean all

.PHONY: all down up ps images logs shell clean fclean re
