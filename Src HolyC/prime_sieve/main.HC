#include <tos.HH>

extern "c" I32 clock_gettime(I32 clk_id, cTimespec *tp);

U0 run_sieve(I64 limit, I64 expected) {
  I64 num_odds = limit / 2;
  U8 *ptr = MAlloc(num_odds);
  MemSet(ptr, 1, num_odds);
  ptr[0] = 0;

  cTimespec start, end;
  clock_gettime(1, &start);

  I64 i;
  for (i = 1; (2 * i + 1) * (2 * i + 1) < limit; ++i) {
    if (ptr[i]) {
      I64 p = 2 * i + 1;
      I64 j = 2 * i * (i + 1);
      I64 p4 = 4 * p;

      while (j + p4 <= num_odds) {
        ptr[j] = 0;
        ptr[j + p] = 0;
        ptr[j + 2 * p] = 0;
        ptr[j + 3 * p] = 0;
        j += p4;
      }

      while (j < num_odds) {
        ptr[j] = 0;
        j += p;
      }
    }
  }

  clock_gettime(1, &end);

  I64 count = 1;
  for (i = 1; i < num_odds; ++i) {
    count += ptr[i];
  }

  F64 elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
  F64 elapsed_s = elapsed_ms / 1000.0;

  printf("  [Sieve]   Limit: %11ld | Primes: %9ld | Time: %10.4f ms (%8.6f s)\n",
         limit, count, elapsed_ms, elapsed_s);

  Free(ptr);
}

I32 main() {
  run_sieve(1000000, 78498);
  run_sieve(10000000, 664579);
  run_sieve(100000000, 5761455);
  run_sieve(1000000000, 50847534);
  return 0;
}
