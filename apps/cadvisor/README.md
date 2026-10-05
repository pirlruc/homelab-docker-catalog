# cadvisor

Host metrics for containers. This service mounts `/`, `/sys`, `/var/run`, and
`/var/lib/docker` read-only and adds `SYS_ADMIN`. Deviation HDC-003 against
`DOCKER-COMPOSE-009`. The Docker socket file is inside `/var/run` because
cAdvisor will not start without the runtime directory. Do not mount the socket
into any other stack.

Bind `BIND_ADDRESS` to the VM address only after the fleet firewall allows
TCP 8080 from 192.168.1.220 and nobody else.

There is no named volume. cAdvisor keeps no state.
