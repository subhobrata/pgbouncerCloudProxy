#!/usr/bin/env bash
set -e

INSTANCE_CONNECTION_NAME=${INSTANCE_CONNECTION_NAME:?Cloud SQL instance connection name must be set}
PROXY_PORT=${PROXY_PORT:-5433}

# Start Cloud SQL Proxy
cloud_sql_proxy -instances=${INSTANCE_CONNECTION_NAME}=tcp:${PROXY_PORT} &
PROXY_PID=$!

# Ensure proxy is terminated when this script exits
trap 'kill -TERM ${PROXY_PID}' TERM INT

# Update pgbouncer configuration to connect through the proxy
sed -i "s/host=127.0.0.1 port=5432/host=127.0.0.1 port=${PROXY_PORT}/" /etc/pgbouncer/pgbouncer.ini

# Launch pgbouncer
exec pgbouncer /etc/pgbouncer/pgbouncer.ini
