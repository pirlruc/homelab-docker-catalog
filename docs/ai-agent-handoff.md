# AI agent handoff — homelab-docker-catalog

## Delivery status

| Item | Status |
|------|--------|
| Stacks under `apps/` | Written. `docker compose config` passes with `tests/*.env`. |
| Traefik and Vaultwarden smoke | Run locally when the image pull finishes. |
| gitlab-mcp HTTP | Compose targets 0.2.0. Digest is still 0.1.0 until that image is published. HDC-001-T1. |
| CI | Calls containerdevops `6.2.1` (`d5241677…`) and commondevops `5.3.2` (`8897e9df…`). |
| Deviations | HDC-003. Review 2026-12-31. |

## Commands

```bash
bash scripts/check-ci-local.sh
docker compose --env-file tests/reverse-proxy.env -f apps/reverse-proxy/compose.yaml up -d --wait
```

## Pins

| Submodule | Pin |
|-----------|-----|
| `docs/guardrails` | tag 1.10.0 |
| `.github/scaffold` | tag 1.8.0 |

Dependabot `gitsubmodule` is not enabled until `DEPENDABOT_GITHUB_TOKEN` exists.
The registries block in `.github/dependabot.yml` stays commented.

## Suggested next work

- Publish gitlab-mcp 0.2.0 and replace the digest in `apps/gitlab-mcp/compose.yaml`.
- Boot dns-core on a host where port 53 is free and record any capability the Pi-hole entrypoint still needs.
- Do not copy Grafana dashboard JSON from home-assistant until the licence is checked.

*Last updated: 2026-10-05*
