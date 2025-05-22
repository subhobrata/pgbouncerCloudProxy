# Use the official Cloud SQL Proxy image to obtain the proxy binary
FROM gcr.io/cloudsql-docker/gce-proxy:1.33.0 as proxy

# Base runtime image
FROM debian:bullseye-slim

# Install pgbouncer
RUN apt-get update \
    && apt-get install -y --no-install-recommends pgbouncer \
    && rm -rf /var/lib/apt/lists/*

# Copy the cloud_sql_proxy binary from the proxy image
COPY --from=proxy /cloud_sql_proxy /usr/local/bin/cloud_sql_proxy

# Copy configuration
COPY pgbouncer.ini /etc/pgbouncer/pgbouncer.ini
COPY userlist.txt /etc/pgbouncer/userlist.txt
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5432

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
