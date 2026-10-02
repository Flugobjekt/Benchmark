import core.stdc.stdlib : malloc, free, exit;
import core.stdc.string : memset;
import core.time : MonoTime, Duration;
import std.stdio : writefln;

void runSieve(size_t limit, size_t expected) {
    size_t numOdds = limit / 2;
    ubyte* ptr = cast(ubyte*) malloc(numOdds);
    if (ptr is null) {
        exit(1);
    }
    memset(ptr, 1, numOdds);
    ptr[0] = 0;

    MonoTime start = MonoTime.currTime;

    for (size_t i = 1; (2 * i + 1) * (2 * i + 1) < limit; ++i) {
        if (ptr[i]) {
            size_t p = 2 * i + 1;
            size_t j = 2 * i * (i + 1);
            size_t p4 = 4 * p;

            while (j + p4 <= numOdds) {
                ptr[j] = 0;
                ptr[j + p] = 0;
                ptr[j + 2 * p] = 0;
                ptr[j + 3 * p] = 0;
                j += p4;
            }

            while (j < numOdds) {
                ptr[j] = 0;
                j += p;
            }
        }
    }

    MonoTime end = MonoTime.currTime;

    size_t count = 1;
    for (size_t i = 1; i < numOdds; ++i) {
        count += ptr[i];
    }

    Duration elapsed = end - start;
    double elapsedMs = cast(double) elapsed.total!"nsecs" / 1_000_000.0;
    double elapsedS = cast(double) elapsed.total!"nsecs" / 1_000_000_000.0;

    writefln("  [Sieve]   Limit: %11d | Primes: %9d | Time: %10.4f ms (%8.6f s)",
             limit, count, elapsedMs, elapsedS);

    assert(count == expected);
    free(ptr);
}

void main() {
    runSieve(1_000_000, 78498);
    runSieve(10_000_000, 664579);
    runSieve(100_000_000, 5761455);
    runSieve(1_000_000_000, 50847534);
}
