#!/bin/bash
set -e

echo "Creating database pg_cron..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE pg_cron;
EOSQL

echo "Adding configuration to postgresql.conf..."
echo "shared_preload_libraries = 'pg_cron'" >> "$PGDATA/postgresql.conf"
echo "cron.database_name = 'pg_cron'" >> "$PGDATA/postgresql.conf"

echo "Restarting internal PostgreSQL server..."
pg_ctl -D "$PGDATA" -m fast -w restart

echo "Installing pg_cron extension in database pg_cron..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "pg_cron" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pg_cron;
EOSQL

echo "Setup pg_cron done!"