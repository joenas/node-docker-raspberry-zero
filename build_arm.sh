#!/bin/bash
########################################################################
# Build the armv6 image and save it to tar
#
# $ ./build_arm.sh -n [IMAGE_NAME]
#
# Pass a hostname:path to transfer the file with `scp`
#
# $ ./build_arm.sh -d host:/home/pi
#
# With npm installed locally you can build the client and fetch node_modules
# then copy them into the image
#
# $ ./build_arm.sh -l
#
########################################################################


# OPTIONS
# From https://stackoverflow.com/a/14203146
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
DESTINATION=""
LOCAL_NPM=0
IMAGE_NAME="node-docker-raspberry-zero"

while getopts "ld:n:" opt; do
    case "$opt" in
    l)  LOCAL_NPM=1
        ;;
    d)  DESTINATION=$OPTARG
        ;;
    n)  IMAGE_NAME=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

# SETUP
TAG="$IMAGE_NAME:armv6"
TAR="$IMAGE_NAME.tar"

if [ $LOCAL_NPM -eq 0 ]
  then
    DOCKERFILE="Dockerfile.armv6"
  else
    DOCKERFILE="Dockerfile.armv6.local_npm"
    npm install
    cd client && npm install && npm run build && cd ..
fi

# Build and save the image
printf "\n--- Building $TAG from $DOCKERFILE\n\n"
docker build -t $TAG -f $DOCKERFILE . #1> /dev/null

printf "\n--- Saving $TAG to '$TAR'\n"
docker save -o $TAR $TAG

# Transfer it
if [ ! -z "$DESTINATION" ]
  then
    printf "\n--- Uploading $TAR to $DESTINATION\n"
    scp "$TAR" $DESTINATION
fi
