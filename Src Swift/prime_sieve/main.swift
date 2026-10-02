import Foundation
#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

func runSieve(limit: Int, expected: Int) {
    let numOdds = limit / 2
    let buffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: numOdds)
    buffer.initialize(repeating: 1)
    buffer[0] = 0
    defer {
        buffer.deallocate()
    }
    let ptr = buffer.baseAddress!

    var start = timespec()
    clock_gettime(CLOCK_MONOTONIC, &start)

    var i = 1
    while (2 * i + 1) * (2 * i + 1) < limit {
        if ptr[i] != 0 {
            let p = 2 * i + 1
            var j = 2 * i * (i + 1)
            let p4 = 4 * p

            while j + p4 <= numOdds {
                ptr[j] = 0
                ptr[j + p] = 0
                ptr[j + 2 * p] = 0
                ptr[j + 3 * p] = 0
                j += p4
            }

            while j < numOdds {
                ptr[j] = 0
                j += p
            }
        }
        i += 1
    }

    var end = timespec()
    clock_gettime(CLOCK_MONOTONIC, &end)

    var count = 1
    for k in 1..<numOdds {
        count += Int(ptr[k])
    }

    let elapsedMs = Double(end.tv_sec - start.tv_sec) * 1000.0 + Double(end.tv_nsec - start.tv_nsec) / 1000000.0
    let elapsedS = elapsedMs / 1000.0

    print(String(format: "  [Sieve]   Limit: %11d | Primes: %9d | Time: %10.4f ms (%8.6f s)", limit, count, elapsedMs, elapsedS))
    assert(count == expected)
}

runSieve(limit: 1000000, expected: 78498)
runSieve(limit: 10000000, expected: 664579)
runSieve(limit: 100000000, expected: 5761455)
runSieve(limit: 1000000000, expected: 50847534)
