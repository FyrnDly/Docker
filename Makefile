.PHONY: docker-build docker-run docker-stop docker-clean docker-install

docker-install:
	@echo "Installing Docker..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	rm get-docker.sh
	@echo "Docker installed."

docker-build:
	@bash scripts/build_compose.sh

docker-run:
	@if [ ! -f docker-compose.yml ]; then \
		echo "docker-compose.yml not found. Running build..."; \
		bash scripts/build_compose.sh; \
	fi
	docker compose up -d

docker-stop:
	docker compose down

docker-clean:
	docker compose down -v
	rm -f docker-compose.yml .env .active_services
	@echo "Cleaned generated configs and removed containers."