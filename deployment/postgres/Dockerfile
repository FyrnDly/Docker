FROM postgres:16

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        postgresql-$PG_MAJOR-postgis-3 \
        postgresql-$PG_MAJOR-postgis-3-scripts \
        postgresql-$PG_MAJOR-cron && \
    rm -rf /var/lib/apt/lists/*

COPY deployment/postgres/scripts/ /docker-entrypoint-initdb.d/
EXPOSE 5432