# homelab-docker-catalog

Public Compose stacks for the homelab. There are no secrets in this repository.
Every variable is `${NAME:?message}`. Images are pinned by digest.

The other two repositories:

- [homelab-infra-tofu](https://github.com/pirlruc/homelab-infra-tofu) creates the virtual machines.
- [homelab-fleet-gitops](https://github.com/pirlruc/homelab-fleet-gitops) holds the secrets and runs these stacks.

`gitlab-server` and `home-assistant` are deprecated. This catalog replaces their
Compose files. Home Assistant itself is Home Assistant OS, not a container here.
Whisper and Piper are add-ons on that OS.

## Stacks

| Directory | Runs on | Notes |
|-----------|---------|-------|
| `apps/reverse-proxy` | Any VM that publishes HTTPS | Traefik file provider, DNS-01 |
| `apps/dns-core` | VM 101 | Pi-hole and Unbound |
| `apps/vaultwarden` | VM 101 | Loopback only, Traefik in front |
| `apps/gitlab-ce` | VM 200 | Omnibus, registry, no bundled runner |
| `apps/buildkit` | VM 201 | Rootless BuildKit |
| `apps/gitlab-mcp` | VM 202 | HTTP mode needs image 0.2.0 |
| `apps/ollama` | VM 202 | CPU only |
| `apps/defectdojo` | VM 300 | DefectDojo 3.4.0 and Valkey |
| `apps/sonarqube-trivy` | VM 300 | Community Build, not LTS |
| `apps/observability` | VM 400 | Prometheus, Loki, Grafana |
| `apps/cadvisor` | Every Docker VM | Host mounts, see the deviation |

## Secrets

This repo does not store secrets and does not decrypt them. Fleet-gitops renders
`/opt/stacks/<app>/.env` mode `0600` from SOPS. Compose reads that file. A missing
variable fails the stack instead of starting with a default.

## Check

```bash
bash scripts/check-ci-local.sh
```
