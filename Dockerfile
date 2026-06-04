FROM docker.io/caddy:2.11.4-builder AS builder

ENV GOFLAGS=-mod=readonly

RUN xcaddy build v2.11.3 \
  --with github.com/caddy-dns/route53@v1.6.2 \
  --with github.com/caddy-dns/cloudflare@v0.2.4 \
  --with github.com/caddyserver/cache-handler@v0.16.0 \
  --with github.com/darkweak/storages/go-redis/caddy@v0.0.19

FROM docker.io/caddy:2.11.4

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN /usr/bin/caddy version && \
  /usr/bin/caddy list-modules --skip-standard --versions

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ["/usr/bin/caddy", "version"]
