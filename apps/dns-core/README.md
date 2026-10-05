# dns-core

Pi-hole forwards to Unbound. Unbound recurses. The router at 192.168.1.1 stays
the DHCP server and hands out this host as the only DNS server.

Port 53 is bound to `BIND_ADDRESS`, not to 127.0.0.1. Clients on the LAN must
reach it. That is deviation HDC-003 against `DOCKER-COMPOSE-006`. The admin UI
stays on 127.0.0.1:8080. Put it behind the reverse proxy if you want it on HTTPS.

## Volumes

| Volume | Backup |
|--------|--------|
| `pihole` | `docker compose stop pihole`, then archive the volume. Restore by extracting into a new volume and starting. |

Unbound has no state.

## Restore check

`dig @<BIND_ADDRESS> example.com` returns an address, and `dig @<BIND_ADDRESS> pi.hole` returns the Pi-hole address.
