# AI agent handoff — homelab-docker-catalog

## Delivery status

| Item | Status |
|------|--------|
| Stacks under `apps/` | Written. `docker compose config` passes with `tests/*.env`. |
| Traefik and Vaultwarden smoke | Run locally when the image pull finishes. |
| gitlab-mcp HTTP | Compose targets 0.2.0. Digest is still 0.1.0 until that image is published. HDC-001-T1. |
| CI | Calls containerdevops `6.2.1` (`d5241677…`) and commondevops `5.3.4` (`98549af7…`). |
| Guardrails / scaffold | guardrails `1.11.0`, scaffold `1.9.0` |
| Deviations | HDC-003, plus the recovery and alert-path gaps recorded under HDC-005. Review 2026-12-31. |

Open work is tracked in [`docs/issues.yml`](issues.yml). The observability and
recovery position is in [`docs/operations.md`](operations.md). What has actually
been run is in [`docs/test-status.md`](test-status.md).

## Commands / CI

```bash
bash scripts/check-ci-local.sh
docker compose --env-file tests/reverse-proxy.env -f apps/reverse-proxy/compose.yaml up -d --wait
```

CI runs container-iac, the commondevops lint, doc-verify, secrets, supply-chain
and scaffold workflows, and a boot check for reverse-proxy and vaultwarden.
The Dependabot jobs gate on `github.event.pull_request.user.login`, not on
`github.actor`, because the actor is whoever triggered the run.

## Known pitfalls

- `scripts/lint-doc-links.py` walks the working tree, not the index, and has no
  exclusion list. A local `.venv/` inside the repository root produces 15 false
  broken links from `ansiblelint`. Move the virtualenv outside the repository
  before running it locally.
- `common-infra-lint` already exposes `run_shfmt`, so shell formatting needs no
  separate job.
- The lychee job is advisory on purpose: a flaky upstream link must not fail the
  build. Link lint and markdownlint are blocking.
- cAdvisor is the only service that mounts `/var/run`. It does not mount
  `/var/run/docker.sock`, and the deviation text has to say both, because
  DOCKER-COMPOSE-009 treats a parent directory of the socket as equivalent to
  the socket.
- The `fleet` scrape job in `apps/observability/config/prometheus.yml` is empty.
  `homelab-fleet-gitops` renders the real `prometheus.yml` from its inventory at
  deploy time, so edit that template rather than the catalog copy.

## Suggested next work

1. HDC-005: give Alertmanager a receiver the operator reads, and record a
   restore from an off-host copy.
2. HDC-001-T1: publish gitlab-mcp 0.2.0 and replace the digest in
   `apps/gitlab-mcp/compose.yaml`.
3. HDC-004-T1: move the boot check to `container-compose-smoke` when it exists.
4. Boot dns-core on a host where port 53 is free and record any capability the
   Pi-hole entrypoint still needs.
5. Do not copy Grafana dashboard JSON from home-assistant until the licence is
   checked.

## Recent history

- `ci`: bump commondevops to `5.3.4`, pass `checkout_token` to every caller, and gate the Dependabot jobs on `github.event.pull_request.user.login`.
- `ci`: add a blocking doc-verify job and an advisory lychee job; turn on `run_shfmt` for the infra-lint caller.
- `feat(scaffold)`: pin guardrails 1.11.0 and scaffold 1.9.0.
- `docs`: state the observability and recovery position, and record the three unmet guardrails as deviations.

*Last updated: 2026-10-16 — guardrails 1.11.0 alignment, the observability and recovery position, and the CI gate fixes.*
