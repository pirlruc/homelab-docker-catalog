# defectdojo

DefectDojo 3.4.0. Nginx listens on 127.0.0.1:8082. Traefik publishes
`https://dojo.lab.<domain>`. Postgres and Valkey have no published ports.

The initializer runs once and must finish before uwsgi starts. A second
`docker compose up` skips initialization when the database is already loaded.

## Volumes

| Volume | Backup |
|--------|--------|
| `postgres` | `docker compose exec postgres pg_dump -U "$DD_DATABASE_USER" "$DD_DATABASE_NAME"`. Restore with `psql` into an empty database, then start the app. |
| `media` | Archive the volume. Findings files live here. |
| `valkey` | Cache only. Safe to delete. |

## Restore check

The login page loads and a previously uploaded report is still listed.
