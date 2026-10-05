# sonarqube-trivy

SonarQube Community Build `26.9.0.129388`. There is no Community LTS line.
Trivy runs in server mode on 127.0.0.1:4954 for CI jobs on the same VM.

The host must set `vm.max_map_count=524288` before SonarQube starts. Compose
cannot set that sysctl. [homelab-fleet-gitops](https://github.com/pirlruc/homelab-fleet-gitops)
sets it on VM 300.

## Volumes

| Volume | Backup |
|--------|--------|
| `db` | `pg_dump` of database `sonar`. Restore into an empty database. |
| `data`, `extensions` | Archive if you need plugins and the embedded search data. A database restore plus empty data directories also works after SonarQube rebuilds its index. |
| `logs`, `trivy-cache` | Safe to delete. |

## Restore check

`/api/system/status` reports `UP` and a previously scanned project is listed.
