# E-Commerce Database

Database schema and migrations for the ecommerce platform.

## Tech Stack

- PostgreSQL 15

## Prerequisites

- PostgreSQL running locally or via Docker

## Setup with Docker

```bash
docker run -d \
  --name ecommerce-db \
  -e POSTGRES_DB=ecommerce \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  -v $(pwd)/schema/init.sql:/docker-entrypoint-initdb.d/init.sql \
  postgres:15
```

## Manual Setup

```bash
psql -U postgres -c "CREATE DATABASE ecommerce;"
psql -U postgres -d ecommerce -f schema/init.sql
psql -U postgres -d ecommerce -f seeds/sample_data.sql
```

## Folder Structure

| Folder      | Purpose                     |
| ----------- | --------------------------- |
| schema/     | Table definitions           |
| seeds/      | Sample data for development |
| migrations/ | Versioned schema changes    |

## Running Migrations

```bash
psql -U postgres -d ecommerce -f migrations/001_initial_schema.sql
```
