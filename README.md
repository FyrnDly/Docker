# Dynamic Local Server with Docker

Welcome to the Dynamic Local Server repository! This repository contains a modular Docker setup designed to make deploying and managing multiple services on a local network straightforward, scalable, and secure.

## 🚀 Features

- **Interactive Service Selection**: A builder script allows you to selectively compose and spin up services using a terminal menu.
- **MinIO Service Integration**: Modern Object Storage (S3 compatible) included for local cloud storage.
- **Centralized Data Storage**: Persistent volume data is kept cleanly separated from configurations to avoid accidental commits and to simplify backups.
- **Nginx Proxy Manager Included**: Built-in dynamic routing via Nginx Proxy Manager

## 📂 Project Structure

A major architectural decision in this repository is the separation of **Docker Compose Templates (`deployment/`)** and **Persistent States (`volumes/`)**. 

The `scripts/build_compose.sh` script dynamically stitches together the isolated service setups from `deployment/` to generate a single `docker-compose.yml` and `.env` root file according to what services you choose.
```text
├── deployment/       # Configuration templates for all applications
│   ├── 00_base.yml   # Docker Compose base (services key)
│   ├── 99_base.yml   # Network configurations
│   ├── adminer/      # Database management UI
│   ├── iot/          # IoT Stack (Node-RED, Mosquitto MQTT)
│   ├── minio/        # MinIO Object Storage (S3 Compatible)
│   ├── mysql/        # MySQL Relational Database
│   ├── nginx-proxy/  # Nginx Proxy Manager (Domain router)
│   ├── portainer/    # Docker visual manager UI
│   ├── postgres/     # PostgreSQL Relational Database
│   └── redis/        # Redis In-memory Datastore
├── volumes/          # Persistent docker volumes
│   ├── database/     # MySQL, Postgres data
│   ├── storage/      # MinIO, general storage
│   └── iot/          # Node-RED, Mosquitto data
├── scripts/          # Bash scripts (Make commands executor)
├── .active_services  # (Auto-generated) State file of current active services
├── .env              # (Auto-generated) Merged environment variables
├── docker-compose.yml# (Auto-generated) Master compose file
├── Makefile          # Main command interface
└── README.md
```

## ⚙️ Prerequisites

- Linux / Ubuntu / Debian Server (Recommended for host) or WSL on Windows
- Docker & Docker Compose
- `make` utility

If your server is fresh, you can leverage our auto-install setup:
```bash
make install
```
*(This commands pulls the official installation scripts from `get.docker.com`)*

## 🛠️ Usage

### 1. Build and Select Services
To spin up your local server, run the interactive builder:

```bash
make build
```

This command will prompt you with a menu. You can selectively type the numbers (e.g. `1 2 4`) of the services you want to compose. It will intelligently pull each service's templated variables and construct a master `docker-compose.yml` and `.env` file on the fly. 

> **Note:** Running `make build` again allows you to **append** new services to your existing active ones without losing previous deployments. If you wish to restart from scratch, type `reset` in the prompt.

### 2. Run the Stack
Once your configuration is generated, launch the background processes with:

```bash
make run
```

### 3. Stop the Stack
To gracefully shut down all active services:

```bash
make stop
```

### 4. Clean generated config
To wipe the auto-generated `docker-compose.yml` and `.env` variables from your directory:

```bash
make clean
```

---
