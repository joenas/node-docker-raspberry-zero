# node-docker-raspberry-zero

Sample Dockerfile and build script for running Node on a Raspberry Pi Zero/1 (armv6)


## Purpose

There is an [image](https://hub.docker.com/r/arm32v6/node/) for Node and `armv6` processors but in my experience if you have even a medium sized project it takes a long time to run `npm install` and I've also had problem with the rpi0 running out of memory. I made this script to easily create the images on a Mac (should work on other OS as well) and then transfer the image to my Pi. That way I can develop my app and the deploy it without having to push to a Docker registry.

## Usage

#### On your local machine

First copy the necessary files to your node-project.

```bash
cp .dockerignore \
   Dockerfile.armv6 \
   Dockerfile.armv6.local_npm \
   build_arm.sh \
   PROJECT_DIR

```

Make sure your Node version is [available](https://hub.docker.com/r/arm32v6/node/tags/) as an image for `armv6` and edit the Dockerfiles accordingly.

Build the armv6 image and save it to a tarball.

```bash
./build_arm.sh -n [IMAGE_NAME]
```

For example `./build_arm.sh -n node-docker-raspberry-zero` will generate a file `node-docker-raspberry-zero.tar` and an image `node-docker-raspberry-zero:armv6`

If you want to transfer the created tar, pass a hostname and path for `scp`
```bash
./build_arm.sh -d host:/home/pi
```

If you have NPM installed locally you can fetch `node_modules` and then copy them into the image (faster). Make sure you local version works with the one in the Dockerfile.
```bash
./build_arm.sh -l
```

#### On your pi
```bash
# Load the transfered tar
docker load -i node-docker-raspberry-zero.tar
```

```bash
docker run  -d --rm --name sample-app \
            -p 5000:5000 \
            node-docker-raspberry-zero:armv6
```


## Contributing

1. Fork it ( https://github.com/joenas/node-docker-raspberry-zero/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [joenas](https://github.com/joenas) joenas - creator, maintainer

