COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/sel-abbo/data

all: 
	@echo "Creating data directories..."
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@echo "Building Inception infrastructure..."
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "Shutting down containers..."
	docker compose -f $(COMPOSE_FILE) down

clean:
	@echo "Stopping and removing containers, networks, and images..."
	docker compose -f $(COMPOSE_FILE) down --rmi all -v

fclean: clean
	@echo "Deep cleaning local volumes and Docker system..."
	@sudo rm -rf $(DATA_DIR)/mariadb
	@sudo rm -rf $(DATA_DIR)/wordpress
	docker system prune -af --volumes

re: fclean all

.PHONY: all down clean fclean re