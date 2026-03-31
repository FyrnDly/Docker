.PHONY: build run stop clean install

install:
	@echo "Installing Docker..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	rm get-docker.sh
	@echo "Docker installed."

build:
	@bash scripts/build_compose.sh

run:
	@if [ ! -f docker-compose.yml ]; then \
		echo "docker-compose.yml not found. Running build..."; \
		bash scripts/build_compose.sh; \
	fi
	docker compose up -d

stop:
	docker compose down

clean:
	rm -f docker-compose.yml .env .active_services
