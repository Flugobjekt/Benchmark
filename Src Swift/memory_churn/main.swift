import Foundation
#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

struct Node {
    let id: Int
    let value: Double
    let name: String
}

var start = timespec()
clock_gettime(CLOCK_MONOTONIC, &start)

var nodes = [Node]()
nodes.reserveCapacity(5_000_000)

for i in 0..<5_000_000 {
    nodes.append(Node(id: i, value: Double(i), name: "Speedtest"))
}

nodes.removeLast(2_000_000)

for i in 3_000_000..<5_000_000 {
    nodes.append(Node(id: i, value: Double(i), name: "Speedtest"))
}

var end = timespec()
clock_gettime(CLOCK_MONOTONIC, &end)

let elapsedMs = Double(end.tv_sec - start.tv_sec) * 1000.0 + Double(end.tv_nsec - start.tv_nsec) / 1000000.0
let elapsedS = elapsedMs / 1000.0

print(String(format: "  [Memory] Final Nodes: %d | Time: %.4f ms (%.6f s)", nodes.count, elapsedMs, elapsedS))
