#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <assert.h>

void run_counter(uint64_t limit) {
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    uint64_t count = 0;
    for (uint64_t i = 1; i <= limit; ++i) {
        count += 1;
        __asm__ volatile("" : "+r"(count));
    }

    clock_gettime(CLOCK_MONOTONIC, &end);

    double elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
    double elapsed_s = elapsed_ms / 1000.0;

    printf("  [Counter] Limit: %11llu | Count:  %9llu | Time: %10.4f ms (%8.6f s)\n",
           (unsigned long long)limit, (unsigned long long)count, elapsed_ms, elapsed_s);

    assert(count == limit);
}

int main(void) {
    run_counter(1000000ULL);
    run_counter(10000000ULL);
    run_counter(100000000ULL);
    run_counter(1000000000ULL);
    return 0;
}
