rm -rf build lit/build/bin/*

cd deps
bash get-llvm-project.sh
cd -

cp deps/llvm-source/build/bin/* lit/build/bin/

cmake -G Ninja -B./build ./ \
  -DMLIR_DIR=./deps/llvm-build/lib/cmake/mlir/ \
  -DLLVM_EXTERNAL_LIT=./lit/build/bin/llvm-lit

ninja -C ./build/
