// RUN: export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
// RUN: g++ -I/usr/local/include/blis -o test_blis test_blis.cpp -lblis

#include <blis.h>
  int main()
  {
    dim_t m = 4, n = 5, k = 3;
    inc_t rsa = 1, csa = m;
    inc_t rsb = 1, csb = k;
    inc_t rsc = 1, csc= m;
    double c[m * n];
    double a[m * k];
    double b[k * n];
    double alpha = 1.0;
	  double beta = 1.0;
    bli_dgemm(BLIS_NO_TRANSPOSE, BLIS_NO_TRANSPOSE,
	            m, n, k, 
              &alpha, a, rsa, csa, 
              b, rsb, csb, 
              &beta, c, rsc, csc);

    // 遍历并打印结果矩阵
    printf("Result matrix:\n");
    for (dim_t i = 0; i < m; i++) {
      for (dim_t j = 0; j < n; j++) {
            printf("%lf ", c[i * n + j]);
        }
        printf("\n");
    }

    return 0;
  }