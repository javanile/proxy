FROM caddy:2.9.1-alpine

RUN apk add --update lighttpd curl && rm -rf /var/cache/apk/*

COPY Caddyfile app /etc/caddy/
COPY cgi-bin /cgi-bin
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
