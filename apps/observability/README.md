# observability

Prometheus, Alertmanager, Loki, and Grafana on VM 400. No published port except
Grafana on 127.0.0.1:3000. Traefik publishes `https://grafana.lab.<domain>`.

`config/prometheus.yml` only scrapes itself. Fleet-gitops replaces that file
with a render of every node_exporter and cAdvisor target. Do not commit the
rendered file back here.

Retention is 15 days in Prometheus and 14 days in Loki. That is the RPO for
metrics and logs. It is not a backup of the other stacks.

`pve-exporter` is behind the `pve` profile because it needs a Proxmox password.
Production enables it with `COMPOSE_PROFILES=pve`. The token is `PVEAuditor`,
not the provisioning token.

Grafana dashboards are not copied from the old home-assistant tree. Those JSON
files were not checked for a licence that allows redistribution. Add dashboards
you are allowed to ship under `config/grafana/provisioning/dashboards`.

## Volumes

| Volume | Backup |
|--------|--------|
| `grafana` | Archive if you care about UI state. Datasources are provisioned and come back from git. |
| `prometheus`, `loki`, `alertmanager` | Metrics and logs. Safe to delete. You lose history, not the ability to start. |

node_exporter and Alloy run on the hosts from fleet-gitops. They are not containers in this stack.
