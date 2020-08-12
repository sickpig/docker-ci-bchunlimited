FROM ubuntu:18.04

# Make sure UTF-8 isn't borked
RUN apt-get -y install locales
RUN export LANG=en_US.UTF-8
RUN export LANGUAGE=en_US:en
RUN export LC_ALL=en_US.UTF-8
RUN echo "en_US UTF-8" > /etc/locale.gen
# Add de_DE.UTF-8 for specific JSON number formatting unit tests
RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
# Generate all locales

RUN locale-gen

RUN apt-get -y update

# Build requirements
RUN apt-get -y --no-install-recommends --no-upgrade -qq automake autotools-dev bsdmainutils build-essential ca-certificates ccache clang-9 curl git libboost-all-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev libdb5.3-dev libdb5.3++-dev libedit2 libevent-dev libminiupnpc-dev libprotobuf-dev libqrencode-dev libssl1.0-dev libssl-dev libtool libzmq3-dev pkg-config protobuf-compiler python3 python3-zmq qttools5-dev qttools5-dev-tools

# Support windows build
RUN apt-get -y install python3 nsis g++-mingw-w64-x86-64 wine64 wine-binfmt curl automake autoconf libtool pkg-config
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix
RUN update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix

# Support ARM build
RUN apt-get -y install autoconf automake curl g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf gperf pkg-config

# Support AArch64 build
RUN apt-get -y install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu qemu-user-static

# Support OSX build
RUN apt-get -y install  cmake imagemagick libcap-dev librsvg2-bin libz-dev libbz2-dev libtiff-tools python-dev python3-setuptools-git

# Clean up cache
RUN apt-get clean
