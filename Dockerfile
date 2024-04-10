FROM ubuntu:22.04 as builder

RUN apt-get update -y && apt-get install -y \
  build-essential cmake gawk \
  libboost-dev python3-dev python3-numpy-dev && \
  rm -rf /var/lib/apt/lists/*

ADD . /src
RUN mkdir build && \
  cd /build && \
  cmake ../src -DCMAKE_INSTALL_PREFIX=/usr/ -DPython_EXECUTABLE=$(which python3) -DBUILD_SHARED_LIBS=TRUE \
  -DBOOST_SUPERPROJECT_VERSION=$(dpkg -s libboost-dev | awk 'match($0,/Version: (([0-9]+\.?){1,3})\./, cap) {print cap[1]}') && \
  make && cpack -G DEB

# two-step install: first deps with default behavior, then package itself, ignoring file overwrites
# apt-get install -y $(apt-get install -s /mnt/boost_python_*.deb | awk '/Inst/ {print $2}' | grep -v boost_python)
# apt-get install -y /mnt/boost_python_*.deb -o Dpkg::Options::="--force-overwrite"