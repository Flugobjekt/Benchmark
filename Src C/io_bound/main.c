#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>

#define NUM_FILES 10000
#define NUM_THREADS 8

static void create_files(void) {
    mkdir("./tmp_io_test", 0777);
    char path[64];
    for (int i = 0; i < NUM_FILES; ++i) {
        snprintf(path, sizeof(path), "./tmp_io_test/file_%d.txt", i);
        int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd >= 0) {
            if (i % 10 == 0) {
                const char data[] = "Line 1: Sample data\nLine 2: Benchmark\nLine 3: End of file\n";
                if (write(fd, data, sizeof(data) - 1) < 0) {}
            } else {
                const char data[] = "Line 1: Sample data\nLine 2: Nothing special\nLine 3: End of file\n";
                if (write(fd, data, sizeof(data) - 1) < 0) {}
            }
            close(fd);
        }
    }
}

typedef struct {
    int start;
    int end;
    int matches;
} ThreadData;

static void* search_files(void *arg) {
    ThreadData *data = (ThreadData *)arg;
    char path[64];
    char buf[256];
    int count = 0;
    for (int i = data->start; i < data->end; ++i) {
        snprintf(path, sizeof(path), "./tmp_io_test/file_%d.txt", i);
        int fd = open(path, O_RDONLY);
        if (fd >= 0) {
            ssize_t n = read(fd, buf, sizeof(buf) - 1);
            if (n > 0) {
                buf[n] = '\0';
                if (strstr(buf, "Benchmark") != NULL) {
                    count++;
                }
            }
            close(fd);
        }
    }
    data->matches = count;
    return NULL;
}

static void cleanup_files(void) {
    char path[64];
    for (int i = 0; i < NUM_FILES; ++i) {
        snprintf(path, sizeof(path), "./tmp_io_test/file_%d.txt", i);
        unlink(path);
    }
    rmdir("./tmp_io_test");
}

int main(void) {
    create_files();

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    pthread_t threads[NUM_THREADS];
    ThreadData tdata[NUM_THREADS];
    int chunk = NUM_FILES / NUM_THREADS;
    for (int t = 0; t < NUM_THREADS; ++t) {
        tdata[t].start = t * chunk;
        tdata[t].end = (t == NUM_THREADS - 1) ? NUM_FILES : (t + 1) * chunk;
        tdata[t].matches = 0;
        pthread_create(&threads[t], NULL, search_files, &tdata[t]);
    }

    int total_matches = 0;
    for (int t = 0; t < NUM_THREADS; ++t) {
        pthread_join(threads[t], NULL);
        total_matches += tdata[t].matches;
    }

    clock_gettime(CLOCK_MONOTONIC, &end);

    cleanup_files();

    double elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
    double elapsed_s = elapsed_ms / 1000.0;
    printf("  [IO-Bound] Files: %d | Matches: %d | Time: %.4f ms (%.6f s)\n", NUM_FILES, total_matches, elapsed_ms, elapsed_s);
    return 0;
}
