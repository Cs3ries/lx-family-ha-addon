ARG BUILD_FROM=ghcr.io/laxxx-lab/lx-family-planner:latest
FROM ${BUILD_FROM}

USER root

COPY run.sh /run.sh
RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
