# gitlab-ce

GitLab Community Edition 18.11 with the container registry. Puma uses 2 workers
and Sidekiq concurrency is 10, sized for a 12 GB VM. The container limit is 10 GB
so the guest OS still has memory.

Omnibus runs as root and cannot use a read-only root filesystem. That is
deviation HDC-003 against `DOCKER-RUN-001`. Prometheus inside Omnibus is off.
VM 400 scrapes node_exporter and cAdvisor instead.

The CI runner is not in this stack. It runs on VM 201 from
[homelab-fleet-gitops](https://github.com/pirlruc/homelab-fleet-gitops).

## Volumes

| Volume | Backup |
|--------|--------|
| `config`, `data` | `docker compose exec gitlab gitlab-backup create`. Also copy `/etc/gitlab/gitlab-secrets.json` from the `config` volume. A backup without that file cannot be restored. |
| `logs` | Not required for restore. |

## Restore

Stop the container. Restore `gitlab-secrets.json` first. Start GitLab, then
`gitlab-backup restore BACKUP=<id>`. Confirm `https://gitlab.lab.<domain>/-/health`.
