#!/bin/bash
set -ex


export CCACHE_DIR=$(pwd)/build-ccache
mkdir -p $CCACHE_DIR

if [ ! -f /usr/local/lib/libz.a ]; then
    pushd zlib
    ./configure CC="ccache cc" CXX="ccache c++" && make -j install
    popd
fi

if [ ! -f  /usr/local/lib/libjpeg.a ]; then
    pushd jpeg
    ./configure CC="ccache cc" CXX="ccache c++" && make -j install
    popd
fi

if [ ! -f /usr/local/lib/libqpdf.a ]; then
    pushd qpdf
    if [[ $(uname -p) == 'aarch64' ]]; then
        ./configure CC="ccache cc" CXX="ccache c++" --disable-oss-fuzz && make install
    else
        ./configure CC="ccache cc" CXX="ccache c++" --disable-oss-fuzz && make -j install
    fi
    find /usr/local/lib -name 'libqpdf.so*' -type f -exec strip --strip-debug {} \+
    popd
fi

ldconfig