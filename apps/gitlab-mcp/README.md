# gitlab-mcp

[pirlruc/gitlab-mcp](https://github.com/pirlruc/gitlab-mcp) over streamable HTTP.
SSE is not used. The bearer secret and the GitLab token are files, not
environment variables. `/healthz` does not require the bearer token. `/mcp` does.

`MCP_ALLOWED_HOSTS` must list every Host header a client will send, including
the port. A request with any other Host is rejected. That stops a browser on
another site from using this port as an open proxy for the GitLab token.

The pinned digest is image `0.1.0`, which is stdio-only. Publish `0.2.0` and
replace the digest before relying on `/healthz`.

There is no named volume. Tokens live on the host and are backed up with the
fleet secret store, not with this stack.
