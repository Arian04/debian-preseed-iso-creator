#!/bin/sh

# This is just a tiny wrapper script so you don't have to memorize arguments

LOCAL_ISO_PATH=${1:?}
LOCAL_PRESEED_PATH=${2:?}
OUTPUT_DIR=${3:?}

docker build \
	--build-arg LOCAL_ISO_PATH="$LOCAL_ISO_PATH" \
	--build-arg LOCAL_PRESEED_PATH="$LOCAL_PRESEED_PATH" \
	--output type=local,dest="$OUTPUT_DIR" \
	.
