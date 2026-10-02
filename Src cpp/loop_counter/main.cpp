#include <iostream>
#include <chrono>
#include <cstdint>
#include <iomanip>
#include <cassert>

void run_counter(uint64_t limit) {
    auto start = std::chrono::steady_clock::now();

    uint64_t count = 0;
    for (uint64_t i = 1; i <= limit; ++i) {
        count += 1;
        asm volatile("" : "+r"(count));
    }

    auto end = std::chrono::steady_clock::now();

    std::chrono::duration<double, std::milli> elapsed_ms = end - start;
    std::chrono::duration<double> elapsed_s = end - start;

    std::cout << "  [Counter] Limit: " << std::setw(11) << limit
              << " | Count:  " << std::setw(9) << count
              << " | Time: " << std::fixed << std::setprecision(4) << std::setw(10) << elapsed_ms.count() << " ms"
              << " (" << std::setprecision(6) << std::setw(8) << elapsed_s.count() << " s)\n";

    assert(count == limit);
}

int main() {
    run_counter(1000000);
    run_counter(10000000);
    run_counter(100000000);
    run_counter(1000000000);
    return 0;
}
