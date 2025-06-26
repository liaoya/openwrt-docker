ARG BASE_IMAGE=ghcr.io/openwrt/buildbot/buildworker-v3.11.8:v21

FROM $BASE_IMAGE

ENV DEBIAN_FRONTEND=noninteractive
RUN set -eux && \
    apt-get update -qy && \
    apt-get install -qy --no-install-recommends \
        nano && \
    rm -rf /var/lib/apt/lists/*

ARG USER=buildbot
ARG WORKDIR=/builder/
ARG CMD="/bin/bash"

ARG DOWNLOAD_FILE
ARG TARGET
ARG FILE_HOST
ARG VERSION_PATH
ARG UPSTREAM_URL
ARG RUN_SETUP

USER $USER
WORKDIR $WORKDIR

ADD --chown=buildbot:buildbot keys/*.asc /builder/keys/
COPY --chmod=0755 setup.sh /builder/setup.sh

ENV DOWNLOAD_FILE=$DOWNLOAD_FILE \
    FILE_HOST=$FILE_HOST \
    RUN_SETUP=$RUN_SETUP \
    TARGET=$TARGET \
    UPSTREAM_URL=$UPSTREAM_URL \
    VERSION_PATH=$VERSION_PATH
RUN if [ $RUN_SETUP -eq 1 ]; then /builder/setup.sh; fi

ENTRYPOINT [ ]

# required to have CMD as ENV to be executed
ENV CMD_ENV=${CMD}
CMD ${CMD_ENV}
