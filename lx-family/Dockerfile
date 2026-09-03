ARG BUILD_FROM=ghcr.io/laxxx-lab/lx-family-planner:latest
FROM ${BUILD_FROM}

USER root

# Install nginx and clean apt cache to keep image lean
RUN apt-get update \
    && apt-get install -y --no-install-recommends nginx \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/nginx/sites-enabled/* /etc/nginx/sites-available/*

# Copy Nginx reverse proxy configuration and entrypoint script
COPY rootfs/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN chmod 755 /run.sh

EXPOSE 3001

ENTRYPOINT ["/run.sh"]
