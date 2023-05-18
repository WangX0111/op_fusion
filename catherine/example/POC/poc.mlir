// RUN: mlir-opt %s -convert-linalg-to-loops -convert-scf-to-cf -convert-linalg-to-llvm -convert-memref-to-llvm -convert-func-to-llvm -reconcile-unrealized-casts | \
// RUN: mlir-cpu-runner -O3 -e main -entry-point-result=void \
// RUN:   -shared-libs=%mlir_lib_dir/libmlir_runner_utils%shlibext \
// RUN: | FileCheck %s
func.func private @printMemrefF32(memref<*xf32>)

func.func @matmul(%A: memref<?x?xf32>, %B: memref<?x?xf32>) -> (memref<?x?xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %f0 = arith.constant 0.0 : f32
  %x = memref.dim %A, %c0 : memref<?x?xf32>
  %y = memref.dim %B, %c1 : memref<?x?xf32>
  %C = memref.alloc(%x, %y) : memref<?x?xf32>
  linalg.fill ins(%f0 : f32) outs(%C : memref<?x?xf32>)
  linalg.matmul ins(%A, %B: memref<?x?xf32>, memref<?x?xf32>)
                outs(%C: memref<?x?xf32>)
  return %C : memref<?x?xf32>
}


// 1.a 
func.func @should_not_fuse_graph_node(){
  return
}

func.func @should_not_fuse_op(){
  return
}


func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index

  %m = arith.constant 1000 : index
  %n1 = arith.constant 500 : index
  %n2 = arith.constant 400 : index
  %p = arith.constant 300 : index

  %val1 = arith.constant 13.0 : f32
  %val2 = arith.constant 17.0 : f32
  %A = memref.alloc(%m, %n1) : memref<?x?xf32>
  %B = memref.alloc(%n1, %n2) : memref<?x?xf32>
  %C = memref.alloc(%n2, %p) : memref<?x?xf32>
  linalg.fill ins(%val1 : f32) outs(%A : memref<?x?xf32>)
  linalg.fill ins(%val1 : f32) outs(%B : memref<?x?xf32>)
  linalg.fill ins(%val2 : f32) outs(%C : memref<?x?xf32>)
  memref.store %val1, %B[%c0, %c0] : memref<?x?xf32>
  %t_start = call @rtclock() : () -> f64
  %D = call @matmul(%A, %B) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  %E = call @matmul(%D, %C) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
  %t_end = call @rtclock() : () -> f64
  %t = arith.subf %t_end, %t_start : f64
  vector.print %t : f64 
  %E_ = memref.cast %E : memref<?x?xf32> to memref<*xf32>
  // call @printMemrefF32(%E_) : (memref<*xf32>) -> ()

  // num_flops_per_iter = 2*M*N*K
  %f1 = arith.muli %m, %n2 : index
  %f2 = arith.muli %f1, %p : index
  %num_flops_per_iter = arith.muli %c2, %f2 : index

  // num_flops_total = num_flops_per_iter * num_reps
  %num_flops_total = arith.muli %num_flops_per_iter, %c1: index

  // Print the number of flops per second
  %num_flops_total_i = arith.index_cast %num_flops_total : index to i16
  %num_flops_total_f = arith.uitofp %num_flops_total_i : i16 to f64
  %flops_per_s = arith.divf %num_flops_total_f, %t : f64
  call @printFlops(%flops_per_s) : (f64) -> ()

  memref.dealloc %A : memref<?x?xf32>
  memref.dealloc %B : memref<?x?xf32>
  memref.dealloc %C : memref<?x?xf32>
  memref.dealloc %D : memref<?x?xf32>
  memref.dealloc %E : memref<?x?xf32>
  return
}

func.func private @printFlops(f64)
func.func private @rtclock() -> f64
