#include <iostream>
#include <vector>
#include <thread>
#include <chrono>
#include <iomanip>
#include <filesystem>
#include <string_view>
#include <fcntl.h>
#include <unistd.h>

namespace fs = std::filesystem;

constexpr int NUM_FILES = 10000;
constexpr int NUM_THREADS = 8;

static void create_files() {
    fs::create_directory("./tmp_io_test");
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

static void cleanup_files() {
    fs::remove_all("./tmp_io_test");
}

int main() {
    create_files();

    auto start = std::chrono::steady_clock::now();

    std::vector<int> matches(NUM_THREADS, 0);
    std::vector<std::thread> threads;
    threads.reserve(NUM_THREADS);
    int chunk = NUM_FILES / NUM_THREADS;

    for (int t = 0; t < NUM_THREADS; ++t) {
        int start_idx = t * chunk;
        int end_idx = (t == NUM_THREADS - 1) ? NUM_FILES : (t + 1) * chunk;
        threads.emplace_back([start_idx, end_idx, &matches, t]() {
            char path[64];
            char buf[256];
            int count = 0;
            for (int i = start_idx; i < end_idx; ++i) {
                snprintf(path, sizeof(path), "./tmp_io_test/file_%d.txt", i);
                int fd = open(path, O_RDONLY);
                if (fd >= 0) {
                    ssize_t n = read(fd, buf, sizeof(buf) - 1);
                    if (n > 0) {
                        buf[n] = '\0';
                        if (std::string_view(buf, n).find("Benchmark") != std::string_view::npos) {
                            count++;
                        }
                    }
                    close(fd);
                }
            }
            matches[t] = count;
        });
    }

    for (auto& t : threads) {
        t.join();
    }

    int total_matches = 0;
    for (int m : matches) {
        total_matches += m;
    }

    auto end = std::chrono::steady_clock::now();

    cleanup_files();

    std::chrono::duration<double, std::milli> elapsed_ms = end - start;
    std::chrono::duration<double> elapsed_s = end - start;

    std::cout << "  [IO-Bound] Files: " << NUM_FILES
              << " | Matches: " << total_matches
              << " | Time: " << std::fixed << std::setprecision(4) << elapsed_ms.count() << " ms"
              << " (" << std::setprecision(6) << elapsed_s.count() << " s)\n";

    return 0;
}
