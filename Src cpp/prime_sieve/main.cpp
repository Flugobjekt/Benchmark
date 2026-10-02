#include <iostream>
#include <vector>
#include <chrono>
#include <cstdint>
#include <iomanip>
#include <cassert>

void run_sieve(size_t limit, size_t expected) {
    size_t num_odds = limit / 2;
    std::vector<uint8_t> is_prime(num_odds, 1);
    if (num_odds > 0) {
        is_prime[0] = 0;
    }

    uint8_t* ptr = is_prime.data();

    auto start = std::chrono::steady_clock::now();

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

    auto end = std::chrono::steady_clock::now();
    asm volatile("" : : "g"(ptr) : "memory");

    size_t prime_count = 1;
    for (size_t i = 1; i < num_odds; ++i) {
        prime_count += ptr[i];
    }

    std::chrono::duration<double, std::milli> elapsed_ms = end - start;
    std::chrono::duration<double> elapsed_s = end - start;

    std::cout << "  [Sieve]   Limit: " << std::setw(11) << limit
              << " | Primes: " << std::setw(9) << prime_count
              << " | Time: " << std::fixed << std::setprecision(4) << std::setw(10) << elapsed_ms.count() << " ms"
              << " (" << std::setprecision(6) << std::setw(8) << elapsed_s.count() << " s)\n";

    assert(prime_count == expected);
}

int main() {
    run_sieve(1000000, 78498);
    run_sieve(10000000, 664579);
    run_sieve(100000000, 5761455);
    run_sieve(1000000000, 50847534);
    return 0;
}
