#!/bin/bash
# -----------
# udSDK 2.1 from official download
# -----------
cp -r /data/udSDK /SOURCE/udsdk # from udSDK_Developer_2.1.zip
cp /SOURCE/udsdk/lib/ubuntu18.04_GCC_x64/libudSDK.so /usr/local/lib

# -----------
# udstream sample program from github
# -----------
cd /SOURCE
git clone --depth 1 https://github.com/Euclideon/udsdksamples
cd udsdksamples/external
git clone --depth 1 https://github.com/Euclideon/udcore

# -----------
# build script and demo build
# -----------
cd /SOURCE/udsdksamples/languages/cpp
cp /data/CMakeLists.txt ./
mkdir build
mkdir bin
cd build
cmake ..
make -j1
