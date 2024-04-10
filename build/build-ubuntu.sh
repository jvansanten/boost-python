#!/bin/bash

# usage: docker run -it --rm -v $(pwd):/src --platform linux/x86_64 ubuntu:22.04 /src/build/build-ubuntu.sh

set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y \
  build-essential cmake gawk \
  libboost-dev python3-dev python3-numpy-dev

cmake make_directory /build && cd /build
cmake ../src -DCMAKE_INSTALL_PREFIX=/usr/ -DPython_EXECUTABLE=$(which python3) -DBUILD_SHARED_LIBS=TRUE \
  -DBOOST_SUPERPROJECT_VERSION=$(dpkg -s libboost-dev | awk 'match($0,/Version: (([0-9]+\.?){1,3})\./, cap) {print cap[1]}')
make
cpack -G DEB
cp *.deb /src
