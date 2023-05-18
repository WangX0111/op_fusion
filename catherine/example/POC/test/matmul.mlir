  module  {
    func.func @matmul(%a : memref<800x800xf16>, %b : memref<800x800xf16>, %c : memref<800x800xf32>) {

      linalg.matmul 
        ins(%a, %b: memref<800x800xf16>, memref<800x800xf16>)
       outs(%c:memref<800x800xf32>)
      return
      }

    // func.func @matmul(%A: memref<?x?xf32>, %B: memref<?x?xf32>) -> (memref<?x?xf32>) {
    //   %c0 = arith.constant 0 : index
    //   %c1 = arith.constant 1 : index
    //   %f0 = arith.constant 0.0 : f32
    //   %x = memref.dim %A, %c0 : memref<?x?xf32>
    //   %y = memref.dim %B, %c1 : memref<?x?xf32>
    //   %C = memref.alloc(%x, %y) : memref<?x?xf32>
    //   linalg.fill ins(%f0 : f32) outs(%C : memref<?x?xf32>)
    //   linalg.matmul ins(%A, %B: memref<?x?xf32>, memref<?x?xf32>)
    //                 outs(%C: memref<?x?xf32>)
    //   return %C : memref<?x?xf32>
    // }
  }

  