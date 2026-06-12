# Include .env file to automatically load MinIO admin credentials if it exists
ifneq ("$(wildcard .env)","")
  include .env
  export
endif

.PHONY: help docker-build docker-run docker-stop docker-clean docker-install docker-backup docker-minio-key

# Default target when simply typing 'make'
help:
	@echo "============================================="
	@echo "   Docker Local Server - Command Helper"
	@echo "============================================="
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help            : Display this help menu"
	@echo "  docker-install  : Install Docker & Docker Compose (For fresh servers)"
	@echo "  docker-build    : Open the interactive menu to toggle services"
	@echo "  docker-run      : Run all built services in detached mode"
	@echo "  docker-stop     : Gracefully stop all services without removing data"
	@echo "  docker-clean    : Remove containers and configs (DOES NOT remove volume data)"
	@echo "  docker-backup   : Backup all active Docker Volumes to the ./backups directory"
	@echo "  minio-add-key	 : Create an S3 Access Key & Secret Key for MinIO"
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

minio-add-key:
	@if [ -z "$(MINIO_ROOT_USER)" ]; then \
		echo "Error: MinIO environment variables not found. Please ensure .env is generated."; \
		exit 1; \
	fi
	@if [ -z "$(ACCESS)" ]; then \
		read -p "Enter Profile Name (This will be your Access Key): " access; \
	else \
		access="$(ACCESS)"; \
	fi; \
	if [ -z "$(SECRET)" ]; then \
		read -s -p "Enter Secret Key (Password, min. 8 characters): " secret; echo ""; \
	else \
		secret="$(SECRET)"; \
	fi; \
	echo "Generating S3 IAM User directly inside the 'minio' container..."; \
	docker exec -it minio sh -c "\
		mc alias set localminio http://localhost:9000 $(MINIO_ROOT_USER) $(MINIO_ROOT_PASSWORD) > /dev/null 2>&1 && \
		mc admin user add localminio $$access $$secret && \
		mc admin policy attach localminio readwrite --user $$access"
	@echo "============================================="
	@echo " ✅ S3 Credentials Created Successfully!"
	@echo " Access Key : $$access"
	@echo " Secret Key : (Hidden)"
	@echo " Policy     : readwrite (Full Access)"
	@echo "============================================="