# Dynamic Local Server with Docker

Welcome to the Dynamic Local Server repository! This repository contains a modular Docker setup designed to make deploying and managing multiple services on a local network straightforward, scalable, and secure.

## 🚀 Features

* **Interactive Service Selection**: A toggle-based builder script allows you to selectively add or remove services using a terminal menu.
* **Docker Named Volumes**: Utilizes Docker's native volume management for better performance, permission handling, and security.
* **MinIO Service Integration**: Modern Object Storage (S3 compatible) included for local cloud storage.
* **Nginx Proxy Manager Included**: Built-in dynamic routing via Nginx Proxy Manager.

## 📂 Project Structure

A major architectural decision in this repository is the separation of **Docker Compose Templates (`deployment/`)** and **Persistent States**.

The `scripts/build_compose.sh` script dynamically stitches together the isolated service setups to generate a single `docker-compose.yml` and `.env` root file.

```text
├── deployment/       # Configuration templates for all applications
│   ├── 00_base.yml   # Docker Compose base (services key)
│   ├── 99_base.yml   # Network and Global Volumes configurations
│   ├── adminer/      # Database management UI
│   ├── iot/          # IoT Stack (Node-RED, Mosquitto MQTT)
│   ├── minio/        # MinIO Object Storage (S3 Compatible)
│   ├── mysql/        # MySQL Relational Database
│   ├── nginx-proxy/  # Nginx Proxy Manager (Domain router)
│   ├── portainer/    # Docker visual manager UI
│   ├── postgres/     # PostgreSQL Relational Database
│   └── redis/        # Redis In-memory Datastore
├── scripts/          # Bash scripts (Make commands executor)
├── .active_services  # (Auto-generated) State file of current active services
├── .env              # (Auto-generated) Merged environment variables
├── docker-compose.yml# (Auto-generated) Master compose file
├── Makefile          # Main command interface
├── LICENSE.md        # MIT License
└── README.md
```

## ⚙️ Prerequisites

* Linux / Ubuntu / Debian Server (Recommended for host) or WSL on Windows
* Docker & Docker Compose
* `make` utility

## 🛠️ Usage

To keep this documentation concise as our tooling grows, this project utilizes a **self-documenting Makefile**.

### View All Available Commands

To discover all available utilities (including fresh installation, data backups, and environment cleanup), simply run the help command in your terminal:

```bash
make help
```

### Core Workflow (Quick Start)

For day-to-day operations, you will primarily use these three essential commands:

**1. Build and Toggle Services**
Run the interactive builder to select which services you want to activate or deactivate:

```bash
make docker-build
```

**2. Start the Server**
Launch your generated configuration in the background:

```bash
make docker-up
```

**3. Stop the Server**
Gracefully shut down all active containers without losing any data:

```bash
make docker-stop
```
