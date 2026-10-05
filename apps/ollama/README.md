# ollama

CPU inference on VM 202. A GPU is not passed through. Adding `/dev/dri` is a
host-specific override and a `DOCKER-COMPOSE-009` decision, not part of this
catalog.

The API is bound to `BIND_ADDRESS`. Do not leave that as `0.0.0.0`.

## Volumes

| Volume | Backup |
|--------|--------|
| `data` | Models can be pulled again. To keep them, stop the container and archive the volume. Restore by extracting into a new volume. |
