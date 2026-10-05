# reverse-proxy

Traefik v3 terminates TLS for the host it runs on. Certificates come from
Let's Encrypt DNS-01. Nothing is published to the internet. Pi-hole resolves
`*.lab.<domain>` to LAN addresses.

The file provider is the only provider. Traefik does not mount the Docker
socket. [homelab-fleet-gitops](https://github.com/pirlruc/homelab-fleet-gitops)
renders `config/dynamic.yml` from inventory. The committed file only sets the
TLS minimum version so `docker compose up` has a valid directory.

## Ports

| Port | Bind | Purpose |
|------|------|---------|
| 80 | `BIND_ADDRESS` | Redirects to HTTPS |
| 443 | `BIND_ADDRESS` | HTTPS |

## Volumes

| Volume | Backup |
|--------|--------|
| `letsencrypt` | Copy `acme.json` after `docker compose stop`. Restore the file before start. Mode `0600`. Losing it only forces re-issue. |

## Smoke

`tests/reverse-proxy.env` uses a dummy DNS token. Traefik stays up on its ping
entrypoint. Issuance fails until the token is real, which is expected.
