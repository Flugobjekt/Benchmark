#include <iostream>
#include <vector>
#include <thread>
#include <chrono>
#include <iomanip>

constexpr int NUM_TASKS = 500;

int main() {
    auto start = std::chrono::steady_clock::now();

    std::vector<std::thread> threads;
    threads.reserve(NUM_TASKS);
    for (int i = 0; i < NUM_TASKS; ++i) {
        threads.emplace_back([]() {
            std::this_thread::sleep_for(std::chrono::milliseconds(200));
        });
    }

    for (auto& t : threads) {
        t.join();
    }

    auto end = std::chrono::steady_clock::now();

    std::chrono::duration<double, std::milli> elapsed_ms = end - start;
    std::chrono::duration<double> elapsed_s = end - start;

    std::cout << "  [Concurrency] Tasks: " << NUM_TASKS
              << " | Delay: 200 ms | Time: "
              << std::fixed << std::setprecision(4) << elapsed_ms.count() << " ms"
              << " (" << std::setprecision(6) << elapsed_s.count() << " s)\n";

    return 0;
}
