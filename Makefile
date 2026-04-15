BUILD_DIR:=$(LLVM_DIR)/build
PREFIX:=$(LLVM_DIR)/destdir

DEBUG_BUILD_DIR:=$(LLVM_DIR)/debug
DEBUG_PREFIX:=$(LLVM_DIR)/destdebugdir

all:
	cmake -G Ninja -B./build . -DMLIR_DIR=$(PREFIX)/lib/cmake/mlir -DLLVM_EXTERNAL_LIT=$(BUILD_DIR)/bin/llvm-lit -DCMAKE_CXX_COMPILER=clang++
	ninja -C ./build
	cp ./scripts/muc_driver ./build/bin
	rm -f compile_commands.json
	ln -s ./build/compile_commands.json

debug:
	cmake -G Ninja -B./build . -DCMAKE_BUILD_TYPE=Debug -DMLIR_DIR=$(DEBUG_PREFIX)/lib/cmake/mlir -DLLVM_EXTERNAL_LIT=$(DEBUG_BUILD_DIR)/bin/llvm-lit
	ninja -C ./build
	cp ./scripts/muc_driver ./build/bin
	rm -f compile_commands.json
	ln -s ./build/compile_commands.json

run: all
	./build/muc --emit=ast ./test/test2.mu

build-muc:
	bash build.sh

test-llvm:
	./lit/build/bin/llvm-lit -sv ./build/test/Mu/llvm-lowering.mu

test-muc:
	bash run_test.sh

clean:
	rm -rf build lit/llvm/utils/lit/lit/__pycache__ lit/llvm/utils/lit/lit/formats/__pycache__ lit/llvm/utils/lit/lit/llvm/__pycache__
	rm -f compile_commands.json lit/build/bin/*

super-clean: clean
	rm -rf deps/llvm-source deps/llvm-build
