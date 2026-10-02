#include <tos.HH>

extern "c" I32 usleep(U32 usec);
extern "c" I32 clock_gettime(I32 clk_id, cTimespec *tp);

U0 task(U0 *arg) {
  usleep(200000);
}

I32 main() {
  cTimespec start, end;
  clock_gettime(1, &start);

  pthread_t *threads[500];
  I64 i;
  for (i = 0; i < 500; ++i) {
    pthread_create(&threads[i], NULL, &task, NULL);
  }

  for (i = 0; i < 500; ++i) {
    pthread_join(threads[i], NULL);
  }

  clock_gettime(1, &end);

  F64 elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
  F64 elapsed_s = elapsed_ms / 1000.0;

  printf("  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: %.4f ms (%.6f s)\n",
         elapsed_ms, elapsed_s);
  return 0;
}
