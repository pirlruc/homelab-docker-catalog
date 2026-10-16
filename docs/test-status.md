# Test status — homelab-docker-catalog

What has actually been run, as of 2026-10-16.

| Component | Host | Status | Evidence command | Remaining gap |
|-----------|------|--------|------------------|---------------|
| Every stack renders | workstation | tested | `docker compose --env-file tests/<app>.env -f apps/<app>/compose.yaml config` | — |
| CI parity script | workstation | tested | `bash scripts/check-ci-local.sh` | — |
| Doc links | workstation | tested | `python3 scripts/lint-doc-links.py` | Run it with the virtualenv outside the repository root |
| reverse-proxy and vaultwarden boot | workstation | blocked | `docker compose --env-file tests/reverse-proxy.env -f apps/reverse-proxy/compose.yaml up -d --wait` | Needs the image pull to finish |
| dns-core boot | VM 101 | blocked | — | Needs a host where port 53 is free |
| gitlab-ce, defectdojo, sonarqube-trivy boot | VM 200, VM 300 | not tested | — | Outside the 12 GB test budget; see `homelab-infra-tofu/docs/test-status.md` |
| Alert path fires and arrives | — | not tested | — | HDC-005; no Alertmanager receiver exists |
| Restore from an off-host copy | — | not tested | — | HFG-OFFSITE; no off-host copy exists |

## Not tested

GitLab CE and the security stack are recorded as not tested for the same reason
as in the other two repositories: the test node has 16 GB and the test budget is
12 GB. GitLab CE alone was measured at roughly 3.9 GiB RSS in
`gitlab-server/docs/ai-agent-handoff.md`.
