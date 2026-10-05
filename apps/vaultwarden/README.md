# vaultwarden

Vaultwarden listens on 127.0.0.1:8081. Traefik publishes `https://vault.lab.<domain>`.
Bitwarden clients need a publicly trusted certificate, which DNS-01 provides.
Do not put Vaultwarden on a private CA.

`SIGNUPS_ALLOWED=false` after the first account exists.

## Volumes

| Volume | Backup |
|--------|--------|
| `data` | Stop the container. `sqlite3 /data/db.sqlite3 ".backup /backup/vaultwarden.sqlite3"`. Copy `rsa_key.pem` and the attachments directory. Restore by stopping, replacing those files, and starting. |

## Restore check

`https://vault.lab.<domain>/alive` returns ok and an existing account unlocks.
