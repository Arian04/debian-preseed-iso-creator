# syntax = docker/dockerfile:1

# image args
ARG IMAGE=debian
ARG IMAGE_TAG=12

# constants
ARG DEST_DIR=/build

##### Create ISO #####
FROM ${IMAGE}:${IMAGE_TAG} AS builder

# constants
ENV SCRIPT_NAME=create-preseed-iso.sh
ARG DEST_DIR

# env vars that the script reads in
ENV SRC_ISO_PATH=/debian.iso
ENV PRESEED_FILE_PATH=/preseed.cfg
ENV DEST_DIR=${DEST_DIR}

# bash - script interpreter
# libarchive-tools - bsdtar
# gzip - gzip + gunzip
# findutils - find + xargs
#
# coreutils are also used but i'm gonna assume it's already installed, which is a safe bet.
RUN apt-get update \
	&& apt-get install --no-install-recommends -y bash libarchive-tools gzip findutils \
	&& rm -rf /var/lib/apt/lists/*

COPY ./debian.iso ${SRC_ISO_PATH}
COPY ./preseed.cfg ${PRESEED_FILE_PATH}

COPY --chmod=555 ./${SCRIPT_NAME} /bin

WORKDIR ${DEST_DIR}
RUN /bin/${SCRIPT_NAME}


##### Output #####
FROM scratch

ARG DEST_DIR
COPY --from=builder ${DEST_DIR} /
