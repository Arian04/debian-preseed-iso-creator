# syntax = docker/dockerfile:1

# image args
ARG IMAGE=debian
ARG IMAGE_TAG=12

# constants
ARG DEST_DIR=/build

# input params
ARG LOCAL_ISO_PATH
ARG LOCAL_PRESEED_PATH

##### Create ISO #####
FROM ${IMAGE}:${IMAGE_TAG} AS builder

# input params
ARG LOCAL_ISO_PATH
ARG LOCAL_PRESEED_PATH

# ensure that the build args are passed
RUN test -n "${LOCAL_ISO_PATH}" || (echo "LOCAL_ISO_PATH not set" && false)
RUN test -n "${LOCAL_PRESEED_PATH}" || (echo "LOCAL_PRESEED_PATH not set" && false)

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
# xorriso - xorriso
# cpio - cpio
#
# coreutils are also used but i'm gonna assume it's already installed, which is a safe bet.
RUN apt-get update \
	&& apt-get install --no-install-recommends -y bash libarchive-tools gzip findutils xorriso cpio \
	&& rm -rf /var/lib/apt/lists/*

COPY --chmod=555 ./${SCRIPT_NAME} /bin

COPY ${LOCAL_ISO_PATH} ${SRC_ISO_PATH}
COPY ${LOCAL_PRESEED_PATH} ${PRESEED_FILE_PATH}

RUN /bin/${SCRIPT_NAME}

##### Output #####
FROM scratch

ARG DEST_DIR
COPY --from=builder ${DEST_DIR}/debian-preseed.iso /

# WORKDIR ${DEST_DIR}
#
# # Set entrypoint as a shell so it can expand the env var in CMD
# ENTRYPOINT [ "sh", "-c" ]
# CMD [ "/bin/${SCRIPT_NAME}" ]
