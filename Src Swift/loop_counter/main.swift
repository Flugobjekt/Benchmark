import Foundation
#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

var sink: Int = 0

@inline(never)
func runCounter(limit: Int) {
    var start = timespec()
    clock_gettime(CLOCK_MONOTONIC, &start)

    var count = 0
    var i = 1
    while i <= limit {
        count += 1
        i += 1
    }

    sink = count

    var end = timespec()
    clock_gettime(CLOCK_MONOTONIC, &end)

    let elapsedMs = Double(end.tv_sec - start.tv_sec) * 1000.0 + Double(end.tv_nsec - start.tv_nsec) / 1000000.0
    let elapsedS = elapsedMs / 1000.0

    print(String(format: "  [Counter] Limit: %11d | Count:  %9d | Time: %10.4f ms (%8.6f s)", limit, count, elapsedMs, elapsedS))
    assert(count == limit)
}

runCounter(limit: 1000000)
runCounter(limit: 10000000)
runCounter(limit: 100000000)
runCounter(limit: 1000000000)
