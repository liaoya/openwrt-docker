ARG BASE_IMAGE=ghcr.io/openwrt/buildbot/buildworker-v3.11.8:v21

FROM $BASE_IMAGE
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
RUN gpg --import /builder/keys/*.asc && rm -rf /builder/keys/

COPY --chmod=0755 setup.sh /builder/setup.sh

ENV RUN_SETUP=$RUN_SETUP DOWNLOAD_FILE=$DOWNLOAD_FILE TARGET=$TARGET FILE_HOST=$FILE_HOST VERSION_PATH=$VERSION_PATH UPSTREAM_URL=$UPSTREAM_URL
RUN echo $DOWNLOAD_FILE $TARGET $FILE_HOST $VERSION_PATH $UPSTREAM_URL
RUN if [ $RUN_SETUP -eq 1 ]; then /builder/setup.sh; fi

ENTRYPOINT [ ]

# required to have CMD as ENV to be executed
ENV CMD_ENV=${CMD}
CMD ${CMD_ENV}
