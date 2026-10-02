#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <assert.h>

void run_sieve(size_t limit, size_t expected) {
    size_t num_odds = limit / 2;
    uint8_t *is_prime = (uint8_t *)malloc(num_odds);
    if (!is_prime) {
        fprintf(stderr, "Memory allocation failed for limit %zu\n", limit);
        exit(1);
    }
    memset(is_prime, 1, num_odds);
    is_prime[0] = 0;

    uint8_t *ptr = is_prime;

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    for (size_t i = 1; (2 * i + 1) * (2 * i + 1) < limit; ++i) {
        if (ptr[i]) {
            size_t p = 2 * i + 1;
            size_t j = 2 * i * (i + 1);
            size_t p4 = 4 * p;

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

    clock_gettime(CLOCK_MONOTONIC, &end);
    __asm__ volatile("" : : "g"(ptr) : "memory");

    size_t count = 1;
    for (size_t i = 1; i < num_odds; ++i) {
        count += ptr[i];
    }

    double elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
    double elapsed_s = elapsed_ms / 1000.0;

    printf("  [Sieve]   Limit: %11zu | Primes: %9zu | Time: %10.4f ms (%8.6f s)\n",
           limit, count, elapsed_ms, elapsed_s);

    assert(count == expected);
    free(is_prime);
}

int main(void) {
    run_sieve(1000000ULL, 78498);
    run_sieve(10000000ULL, 664579);
    run_sieve(100000000ULL, 5761455);
    run_sieve(1000000000ULL, 50847534);
    return 0;
}
