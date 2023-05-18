module {
  func.func private @printMemrefF32(memref<*xf32>)
  func.func @matmul(%arg0: memref<?x?xf32>, %arg1: memref<?x?xf32>) -> memref<?x?xf32> {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %dim = memref.dim %arg0, %c0 : memref<?x?xf32>
    %dim_0 = memref.dim %arg1, %c1 : memref<?x?xf32>
    %alloc = memref.alloc(%dim, %dim_0) : memref<?x?xf32>
    scf.for %arg2 = %c0 to %dim step %c1 {
      scf.for %arg3 = %c0 to %dim_0 step %c1 {
        memref.store %cst, %alloc[%arg2, %arg3] : memref<?x?xf32>
      }
    }
    %dim_1 = memref.dim %arg0, %c0 : memref<?x?xf32>
    %dim_2 = memref.dim %arg0, %c1 : memref<?x?xf32>
    %dim_3 = memref.dim %arg1, %c1 : memref<?x?xf32>
    scf.for %arg2 = %c0 to %dim_1 step %c1 {
      scf.for %arg3 = %c0 to %dim_3 step %c1 {
        scf.for %arg4 = %c0 to %dim_2 step %c1 {
          %0 = memref.load %arg0[%arg2, %arg4] : memref<?x?xf32>
          %1 = memref.load %arg1[%arg4, %arg3] : memref<?x?xf32>
          %2 = memref.load %alloc[%arg2, %arg3] : memref<?x?xf32>
          %3 = arith.mulf %0, %1 : f32
          %4 = arith.addf %2, %3 : f32
          memref.store %4, %alloc[%arg2, %arg3] : memref<?x?xf32>
        }
      }
    }
    return %alloc : memref<?x?xf32>
  }
  func.func @main() {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 7.168000e+03 : f64
    %c1000 = arith.constant 1000 : index
    %c500 = arith.constant 500 : index
    %c400 = arith.constant 400 : index
    %c300 = arith.constant 300 : index
    %cst_0 = arith.constant 1.300000e+01 : f32
    %cst_1 = arith.constant 1.700000e+01 : f32
    %alloc = memref.alloc(%c1000, %c500) : memref<?x?xf32>
    %alloc_2 = memref.alloc(%c500, %c400) : memref<?x?xf32>
    %alloc_3 = memref.alloc(%c400, %c300) : memref<?x?xf32>
    scf.for %arg0 = %c0 to %c1000 step %c1 {
      scf.for %arg1 = %c0 to %c500 step %c1 {
        memref.store %cst_0, %alloc[%arg0, %arg1] : memref<?x?xf32>
      }
    }
    scf.for %arg0 = %c0 to %c500 step %c1 {
      scf.for %arg1 = %c0 to %c400 step %c1 {
        memref.store %cst_0, %alloc_2[%arg0, %arg1] : memref<?x?xf32>
      }
    }
    scf.for %arg0 = %c0 to %c400 step %c1 {
      scf.for %arg1 = %c0 to %c300 step %c1 {
        memref.store %cst_1, %alloc_3[%arg0, %arg1] : memref<?x?xf32>
      }
    }
    memref.store %cst_0, %alloc_2[%c0, %c0] : memref<?x?xf32>
    %0 = call @rtclock() : () -> f64
    %1 = call @matmul(%alloc, %alloc_2) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
    %2 = call @matmul(%1, %alloc_3) : (memref<?x?xf32>, memref<?x?xf32>) -> memref<?x?xf32>
    %3 = call @rtclock() : () -> f64
    %4 = arith.subf %3, %0 : f64
    vector.print %4 : f64
    %5 = arith.divf %cst, %4 : f64
    call @printFlops(%5) : (f64) -> ()
    memref.dealloc %alloc : memref<?x?xf32>
    memref.dealloc %alloc_2 : memref<?x?xf32>
    memref.dealloc %alloc_3 : memref<?x?xf32>
    memref.dealloc %1 : memref<?x?xf32>
    memref.dealloc %2 : memref<?x?xf32>
    return
  }
  func.func private @printFlops(f64)
  func.func private @rtclock() -> f64
}

