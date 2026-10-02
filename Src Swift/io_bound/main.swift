import Foundation
#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

let dir = "./tmp_io_test"
mkdir(dir, 0o777)

let matchContent = "Line 1: Sample data\nLine 2: Benchmark\nLine 3: End of file\n"
let noMatchContent = "Line 1: Sample data\nLine 2: Nothing special\nLine 3: End of file\n"

for i in 0..<10000 {
    let path = "\(dir)/file_\(i).txt"
    let fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0o644)
    if fd >= 0 {
        if i % 10 == 0 {
            _ = matchContent.withCString { write(fd, $0, matchContent.utf8.count) }
        } else {
            _ = noMatchContent.withCString { write(fd, $0, noMatchContent.utf8.count) }
        }
        close(fd)
    }
}

var start = timespec()
clock_gettime(CLOCK_MONOTONIC, &start)

var totalMatches = 0
let lock = NSLock()
let numWorkers = 8
let chunkSize = 10000 / numWorkers

DispatchQueue.concurrentPerform(iterations: numWorkers) { worker in
    let startIdx = worker * chunkSize
    let endIdx = (worker == numWorkers - 1) ? 10000 : (worker + 1) * chunkSize
    var localMatches = 0
    var buf = [CChar](repeating: 0, count: 256)
    for i in startIdx..<endIdx {
        let path = "\(dir)/file_\(i).txt"
        let fd = open(path, O_RDONLY)
        if fd >= 0 {
            let n = read(fd, &buf, 255)
            if n > 0 {
                buf[n] = 0
                if strstr(buf, "Benchmark") != nil {
                    localMatches += 1
                }
            }
            close(fd)
        }
    }
    lock.lock()
    totalMatches += localMatches
    lock.unlock()
}

var end = timespec()
clock_gettime(CLOCK_MONOTONIC, &end)

let elapsedMs = Double(end.tv_sec - start.tv_sec) * 1000.0 + Double(end.tv_nsec - start.tv_nsec) / 1000000.0
let elapsedS = elapsedMs / 1000.0
print(String(format: "  [IO-Bound] Files: 10000 | Matches: %d | Time: %.4f ms (%.6f s)", totalMatches, elapsedMs, elapsedS))

for i in 0..<10000 {
    let path = "\(dir)/file_\(i).txt"
    unlink(path)
}
rmdir(dir)
