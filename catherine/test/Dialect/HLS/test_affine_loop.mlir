
#two = affine_map<(d0)[s0] -> (d0, d0 + s0)>
#three = affine_map<(d0)[s0] -> (d0 - s0, d0, d0 + s0)>

func @test_affine_for(%arg0: memref<16xf32>, %arg1: index) {
  %c11 = constant 11 : index


  affine.for %i = 0 to min #two (%arg1)[%c11] step 2 {


    affine.for %j = max #three (%arg1)[%c11] to 16 {

      affine.for %k = 0 to 16 step 2 {

        %0 = load %arg0[%i] : memref<16xf32>


      }

    }

  }
  return
}

func @test_affine_parallel(%arg0: memref<16xf32>) {

  %0:2 = affine.parallel (%x, %y, %z) = (0, 0, 0) to (2, 4, 8) step (1, 2, 3) reduce ("maxs", "addi") -> (index, index){

    affine.yield %x, %y : index, index


  }
  return
}
