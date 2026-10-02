import Foundation
#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

var start = timespec()
clock_gettime(CLOCK_MONOTONIC, &start)

await withTaskGroup(of: Void.self) { group in
    for _ in 0..<500 {
        group.addTask {
            try? await Task.sleep(nanoseconds: 200_000_000)
        }
    }
}

var end = timespec()
clock_gettime(CLOCK_MONOTONIC, &end)

let elapsedMs = Double(end.tv_sec - start.tv_sec) * 1000.0 + Double(end.tv_nsec - start.tv_nsec) / 1000000.0
let elapsedS = elapsedMs / 1000.0
print(String(format: "  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: %.4f ms (%.6f s)", elapsedMs, elapsedS))
