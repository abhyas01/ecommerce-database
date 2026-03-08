FROM postgres:15-alpine

COPY schema/init.sql /docker-entrypoint-initdb.d/01_schema.sql
COPY seeds/sample_data.sql /docker-entrypoint-initdb.d/02_seeds.sql

EXPOSE 5432