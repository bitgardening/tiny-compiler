#!/bin/bash

rm -rf LLVM* llvm*

ARCH="NONE"

if [ "$(uname -m)" = "x86_64" ]; then
    echo "Running on x86_64"
		ARCH=X64
elif [ "$(uname -m)" = "aarch64" ]; then
    echo "Running on ARM64"
		ARCH=ARM64
else
    echo "Other Architecture"
		exit 0
fi

wget https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.3/LLVM-22.1.3-Linux-$ARCH.tar.xz
tar xf LLVM*.tar.xz
rm LLVM*.tar.xz
mv LLVM* llvm-build

wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-22.1.3.tar.gz
tar xf llvmorg-*.tar.gz
rm llvmorg-*.tar.gz
mv llvm-project-llvmorg* llvm-source

cmake -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_CCACHE_BUILD=OFF \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DMLIR_ENABLE_BINDINGS_PYTHON=OFF \
  -DLLVM_ENABLE_ZSTD=OFF \
  -DLLVM_TARGETS_TO_BUILD=Native \
  -DLLVM_ENABLE_PROJECTS=llvm \
  -B./llvm-source/build ./llvm-source/llvm

ninja -C ./llvm-source/build not count FileCheck

