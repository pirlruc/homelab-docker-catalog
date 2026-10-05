# buildkit

Rootless BuildKit for CI image builds. The GitLab runner on the same VM uses
`tcp://127.0.0.1:1234` and does not use a privileged Docker executor.

`seccomp:unconfined` and `apparmor:unconfined` are required by the upstream
rootless image. Deviation HDC-003. Do not add the Docker socket.

## Volumes

| Volume | Backup |
|--------|--------|
| `data` | Cache only. Deleting it is safe. The next build refills it. |
