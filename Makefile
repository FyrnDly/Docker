.PHONY: help docker-build docker-up docker-stop docker-clean docker-install docker-backup

# Default target when simply typing 'make'
help:
	@echo "============================================="
	@echo "   Docker Local Server - Command Helper"
	@echo "============================================="
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help           : Display this help menu"
	@echo "  docker-install : Install Docker & Docker Compose (For fresh servers)"
	@echo "  docker-build   : Open the interactive menu to toggle services"
	@echo "  docker-up     : Run all built services in detached mode"
	@echo "  docker-stop    : Gracefully stop all services without removing data"
	@echo "  docker-clean   : Remove containers and configs (DOES NOT remove volume data)"
	@echo "  docker-backup  : Backup all active Docker Volumes to the ./backups directory"
	@echo "============================================="

docker-install:
	@echo "Installing Docker..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	rm get-docker.sh
	@echo "Docker installed."

docker-build:
	@bash scripts/build_compose.sh

docker-up:
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

docker-backup:
	@bash scripts/backup_volumes.sh