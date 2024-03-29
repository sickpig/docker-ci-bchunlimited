FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get install -y --no-install-recommends --no-upgrade -qq software-properties-common
RUN add-apt-repository -y universe

# Make sure UTF-8 isn't borked
RUN apt-get -y --no-install-recommends --no-upgrade -qq install locales
RUN export LANG=en_US.UTF-8
RUN export LANGUAGE=en_US:en
RUN export LC_ALL=en_US.UTF-8
RUN echo "en_US UTF-8" > /etc/locale.gen
# Add de_DE.UTF-8 for specific JSON number formatting unit tests
RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
# Generate all locales

RUN locale-gen

# Build requirements
RUN apt-get -y --no-install-recommends --no-upgrade -qq install g++-multilib automake autotools-dev bsdmainutils build-essential ca-certificates ccache clang clang-9 clang-10 curl
RUN apt-get -y --no-install-recommends --no-upgrade -qq install git libboost-all-dev
RUN apt-get -y --no-install-recommends --no-upgrade -qq install libdb5.3-dev libdb5.3++-dev libedit2 libevent-dev libminiupnpc-dev libprotobuf-dev libqrencode-dev libssl1.0-dev
RUN apt-get -y --no-install-recommends --no-upgrade -qq install libtool libzmq3-dev pkg-config protobuf-compiler python3 python3-zmq qttools5-dev qttools5-dev-tools bison

#Add clang-format 12
RUN apt-get install -y wget gpg-agent
#needed for libstdc++ with C++20 support in ubuntu 18.04 for clang15
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x ./llvm.sh
RUN ./llvm.sh 12
RUN ./llvm.sh 15
RUN apt-get install clang-format-12 clang-format-15

#Add GNU mp bignum library
RUN apt-get install -y libgmp-dev

#Support linux 32 cross compile on linux64
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y --no-install-recommends --no-upgrade -qq install linux-libc-dev:i386

# Support windows build
RUN apt-get -y --no-install-recommends --no-upgrade -qq install python3 nsis g++-mingw-w64-i686 g++-mingw-w64-x86-64 wine64 wine-binfmt curl automake autoconf libtool pkg-config
RUN update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix
RUN update-alternatives --set x86_64-w64-mingw32-gcc /usr/bin/x86_64-w64-mingw32-gcc-posix
RUN update-alternatives --set i686-w64-mingw32-g++ /usr/bin/i686-w64-mingw32-g++-posix
RUN update-alternatives --set i686-w64-mingw32-gcc /usr/bin/i686-w64-mingw32-gcc-posix

# Support ARM build
RUN apt-get -y --no-install-recommends --no-upgrade -qq install autoconf automake curl g++-arm-linux-gnueabihf gcc-arm-linux-gnueabihf gperf pkg-config

# Support AArch64 build
RUN apt-get -y --no-install-recommends --no-upgrade -qq install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu qemu-user-static

# Support OSX build
RUN apt-get -y --no-install-recommends --no-upgrade -qq install  cmake imagemagick python3-git libcap-dev librsvg2-bin libz-dev libbz2-dev libtiff-tools python-dev python3-setuptools-git python3-setuptools

# Add tools to debug failing QA tests
RUN apt-get -y --no-install-recommends --no-upgrade -qq install python3-pip gdb python3-dev
RUN pip3 install wheel
RUN pip3 install psutil

# Clean up cache
RUN apt-get clean
