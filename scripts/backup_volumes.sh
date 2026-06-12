#!/bin/bash

# Configuration
BASE_BACKUP_DIR="./backups"
FOLDER_DATE=$(date +%y%m%d) # Format: YYMMDD (e.g., 260612)
FILE_TIME=$(date +%H%M%S)   # Format: HHMMSS (e.g., 143502)
TARGET_BACKUP_DIR="$BASE_BACKUP_DIR/$FOLDER_DATE"

echo "============================================="
echo "   Docker Named Volume Backup Tool"
echo "============================================="

if [ ! -f "docker-compose.yml" ]; then
    echo "Error: docker-compose.yml not found."
    echo "Please run 'make docker-build' first to generate your configuration."
    exit 1
fi

# Create targeted subfolder (e.g., ./backups/260612) if it doesn't exist
mkdir -p "$TARGET_BACKUP_DIR"

# 1. Gracefully stop running containers
echo "[1/4] Stopping running containers to ensure data integrity..."
docker compose stop

# 2. Detect all volumes declared in docker-compose.yml
VOLUMES=$(docker compose config --volumes)

if [ -z "$VOLUMES" ]; then
    echo "No named volumes found in the current configuration."
    echo "Restarting containers..."
    docker compose start
    exit 0
fi

echo "[2/4] Identifying volume prefixes..."
echo ""

# Get current project directory name (default Compose project name)
PROJECT_NAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]//g')

# 3. Backup Process
for VOL in $VOLUMES; do
    # Try method 1: Find by Docker Compose labels
    FULL_VOL_NAME=$(docker volume ls --filter label=com.docker.compose.project.working_dir="$PWD" --filter label=com.docker.compose.volume="$VOL" --format "{{.Name}}")
    
    # Try method 2: Fallback for manually created/migrated volumes (Without labels)
    if [ -z "$FULL_VOL_NAME" ]; then
        EXPECTED_NAME="${PROJECT_NAME}_${VOL}"
        # Check if the expected volume name actually exists in Docker
        if docker volume inspect "$EXPECTED_NAME" > /dev/null 2>&1; then
            FULL_VOL_NAME="$EXPECTED_NAME"
        fi
    fi
    
    if [ -n "$FULL_VOL_NAME" ]; then
        echo "📦 Backing up: $VOL ($FULL_VOL_NAME)..."
        
        # Mount volume and compress it into the specific subfolder with exact time formatting
        docker run --rm \
            -v "$FULL_VOL_NAME":/volume_data:ro \
            -v "$(pwd)/$TARGET_BACKUP_DIR":/backup_dir \
            alpine tar -czf /backup_dir/${VOL}_${FILE_TIME}.tar.gz -C /volume_data .
            
        echo "   -> Saved to $TARGET_BACKUP_DIR/${VOL}_${FILE_TIME}.tar.gz"
    else
        echo "⚠️  Warning: Volume '$VOL' is declared but cannot be found or is empty (Skipping)."
    fi
done

echo ""
# 4. Restart containers
echo "[3/4] Restarting containers..."
docker compose start

echo "[4/4] Backup completed successfully!"
echo "Your backups are safely stored in: $(pwd)/$TARGET_BACKUP_DIR"
