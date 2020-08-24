#!/bin/bash

TARGET_DIR=$(pwd)

cd ../../fCore_has

ls .

cp -r includes/fcore_has $TARGET_DIR
mkdir build_server
cd build_server
cmake ../
cmake --build . -j4 --target fchas
cp src/libfchas.so $TARGET_DIR/

cd ..
rm -r build_server
cd $TARGET_DIR