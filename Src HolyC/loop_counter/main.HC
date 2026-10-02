#include <tos.HH>

extern "c" I32 clock_gettime(I32 clk_id, cTimespec *tp);

U0 run_counter(I64 limit) {
  cTimespec start, end;
  clock_gettime(1, &start);

  I64 count = 0;
  I64 i;
  for (i = 1; i <= limit; ++i) {
    count++;
  }

  clock_gettime(1, &end);

  F64 elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
  F64 elapsed_s = elapsed_ms / 1000.0;

  printf("  [Counter] Limit: %11ld | Count:  %9ld | Time: %10.4f ms (%8.6f s)\n",
         limit, count, elapsed_ms, elapsed_s);
}

I32 main() {
  run_counter(1000000);
  run_counter(10000000);
  run_counter(100000000);
  run_counter(1000000000);
  return 0;
}
