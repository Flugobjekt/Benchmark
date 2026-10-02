#include <stdio.h>
#include <time.h>
#include <pthread.h>

#define NUM_TASKS 500

static void* task(void *arg) {
    (void)arg;
    struct timespec ts = {0, 200000000L};
    nanosleep(&ts, NULL);
    return NULL;
}

int main(void) {
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    pthread_t threads[NUM_TASKS];
    for (int i = 0; i < NUM_TASKS; ++i) {
        pthread_create(&threads[i], NULL, task, NULL);
    }

    for (int i = 0; i < NUM_TASKS; ++i) {
        pthread_join(threads[i], NULL);
    }

    clock_gettime(CLOCK_MONOTONIC, &end);

    double elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
    double elapsed_s = elapsed_ms / 1000.0;
    printf("  [Concurrency] Tasks: %d | Delay: 200 ms | Time: %.4f ms (%.6f s)\n", NUM_TASKS, elapsed_ms, elapsed_s);
    return 0;
}
