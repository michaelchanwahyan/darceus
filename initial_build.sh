#!/bin/bash
cd /SOURCE
git clone https://github.com/Euclideon/udsdksamples
cd udsdksamples/external
git clone https://github.com/Euclideon/udcore
cp /SOURCE/udsdk/lib/ubuntu18.04_GCC_x64/libudSDK.so /usr/local/lib
cd /SOURCE/udsdksamples/languages/cpp
cp /data/CMakeLists.txt ./
cp -r /data/udSDK /SOURCE/udsdk
mkdir build
cd build
cmake ..
make
