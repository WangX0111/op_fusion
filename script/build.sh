test -d build || mkdir build
cd build
cmake -G Ninja ../llvm \
	   -DLLVM_ENABLE_PROJECTS="mlir" \
	      -DLLVM_TARGETS_TO_BUILD="host;RISCV" \
	         -DCMAKE_BUILD_TYPE=Release \
		    -DLLVM_ENABLE_ASSERTIONS=ON \
		       -DLLVM_ENABLE_RTTI=ON

ninja check-mlir 
