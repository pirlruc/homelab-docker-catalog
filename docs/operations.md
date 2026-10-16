# Operations — observability, backup and recovery

The stacks in this repository define state, so this file states the
observability and recovery position for them. Guardrail references point at
[`docs/guardrails/`](guardrails/).

## Observability

### Exporter binding — INFRA-OBS-001

| Exporter | Binds | Why |
|----------|-------|-----|
| cAdvisor | `${BIND_ADDRESS:?}` | The operator names the management address. There is no `0.0.0.0` default. |
| Grafana | `127.0.0.1:3000` | Reached through Traefik, never directly. |
| Prometheus, Loki, Alertmanager | No published port | Reachable only on the stack network. |
| node_exporter | Every interface | **Gap.** The `telemetry_agent` role in `homelab-fleet-gitops` installs the distro package and never sets `--web.listen-address`. Recorded there as deviation INFRA-OBS-001. |

### Retention — INFRA-OBS-002

| Store | Retention | Set by |
|-------|-----------|--------|
| Prometheus | `PROMETHEUS_RETENTION` | The operator. Compose has no default, so the stack refuses to start without it. |
| Loki | 336 h (14 days) | `limits_config.retention_period` in `config/loki.yml`, enforced by the compactor. |
| Alertmanager | 5 days | The upstream default, not overridden. |
| Grafana | Unbounded named volume | Dashboards and users only. |

### Alert path — INFRA-OBS-003

**Gap.** `config/alertmanager.yml` routes to a `default` receiver with no
integration, so Alertmanager accepts an alert and drops it. No alert has ever
fired, and `config/prometheus.yml` declares no `rule_files`, so there is
nothing to fire. The `fleet` scrape job is empty here because
`homelab-fleet-gitops` renders the real `prometheus.yml` from its inventory at
deploy time. Tracked as HDC-005.

## Backup and recovery

### What holds state

Compose prefixes each volume with its project name.

| Volume | Stack | Contents |
|--------|-------|----------|
| `gitlab-ce_config`, `gitlab-ce_logs`, `gitlab-ce_data` | `apps/gitlab-ce` | Omnibus configuration, logs, repositories and the registry |
| `vaultwarden_data` | `apps/vaultwarden` | The password vault |
| `observability_prometheus`, `observability_loki`, `observability_grafana`, `observability_alertmanager` | `apps/observability` | Metrics, logs, dashboards, silences |
| `dns-core_pihole` | `apps/dns-core` | Pi-hole configuration |
| `reverse-proxy_letsencrypt` | `apps/reverse-proxy` | Issued certificates |
| `defectdojo_postgres`, `defectdojo_valkey`, `defectdojo_media` | `apps/defectdojo` | Findings and scan history |
| `sonarqube-trivy_db`, `sonarqube-trivy_data`, `sonarqube-trivy_extensions`, `sonarqube-trivy_logs`, `sonarqube-trivy_trivy-cache` | `apps/sonarqube-trivy` | Analysis history |
| `buildkit_data`, `ollama_data` | `apps/buildkit`, `apps/ollama` | Cache only. Safe to lose |

### Current position

| Guardrail | Position |
|-----------|----------|
| INFRA-DR-001 RPO and RTO stated | Local only, 14-day retention, no off-host copy. The targets are RPO 24 h and RTO 4 h. **Neither is met today.** |
| INFRA-DR-002 the copy is off-host | **Not met.** `stack_backup` in `homelab-fleet-gitops` writes `/var/backups/stacks` on the guest it protects and deletes files older than 14 days. Proxmox `vzdump` writes to the same host. |
| INFRA-DR-003 a restore test has been run | **Not met.** No guest has been restored, because no guest is running yet. |

The two unmet guardrails are recorded in
[`guardrail-deviations.yml`](guardrail-deviations.yml) under epic HFG-OFFSITE.

### Restore procedure

1. Stop the stack: `docker compose -f apps/<app>/compose.yaml down`.
2. Restore the named volume from the archive.
3. Start the stack and confirm the healthcheck passes.

`apps/gitlab-ce/README.md` and `apps/vaultwarden/README.md` carry the
application-specific steps.
