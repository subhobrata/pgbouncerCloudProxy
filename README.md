# pgbouncerCloudProxy

This repository contains a minimal setup for running [pgbouncer](https://www.pgbouncer.org/) in front of a Google Cloud SQL for PostgreSQL instance. The container bundles the [Cloud SQL Auth Proxy](https://cloud.google.com/sql/docs/postgres/connect-auth-proxy) alongside pgbouncer so that client applications only need to connect to the local pgbouncer port.

## Directory structure

- `Dockerfile` - builds an image with the Cloud SQL Auth Proxy and pgbouncer
- `entrypoint.sh` - startup script that launches both the proxy and pgbouncer
- `pgbouncer.ini` - pgbouncer configuration template
- `userlist.txt` - list of users and password hashes for pgbouncer

## Building the image

```
docker build -t my-pgbouncer-proxy .
```

## Running

```
docker run \
  -e INSTANCE_CONNECTION_NAME="<PROJECT>:<REGION>:<INSTANCE>" \
  -e DB_USER=postgres \
  -e PROXY_PORT=5433 \
  -p 5432:5432 \
  my-pgbouncer-proxy
```

- `INSTANCE_CONNECTION_NAME` is the Cloud SQL instance connection name in `project:region:instance` format.
- `PROXY_PORT` is the local port used for the Cloud SQL Proxy (default: `5433`). pgbouncer listens on port `5432` inside the container and forwards traffic to the proxy.

You may customize `pgbouncer.ini` and `userlist.txt` to suit your needs.

## Notes

This example demonstrates the structure needed to run the Cloud SQL Proxy with pgbouncer. For production deployments ensure that the `userlist.txt` file contains strong password hashes and that sensitive data is stored securely (for example using Kubernetes secrets or other secret management systems).
