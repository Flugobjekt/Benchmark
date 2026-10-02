import Foundation
#if canImport(Glibc)
import Glibc
#elseif canImport(Darwin)
import Darwin
#endif

final class ServerState: @unchecked Sendable {
    var end = timespec()
}

let serverFd = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
var opt: Int32 = 1
setsockopt(serverFd, SOL_SOCKET, SO_REUSEADDR, &opt, socklen_t(MemoryLayout<Int32>.size))

var addr = sockaddr_in()
addr.sin_family = sa_family_t(AF_INET)
addr.sin_port = 0
inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr)

_ = withUnsafePointer(to: &addr) { ptr in
    ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        bind(serverFd, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
    }
}

listen(serverFd, 1)

var len = socklen_t(MemoryLayout<sockaddr_in>.size)
_ = withUnsafeMutablePointer(to: &addr) { ptr in
    ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        getsockname(serverFd, $0, &len)
    }
}
let port = addr.sin_port

let sem = DispatchSemaphore(value: 0)
let state = ServerState()
let serverThread = Thread {
    var clientAddr = sockaddr_in()
    var clientLen = socklen_t(MemoryLayout<sockaddr_in>.size)
    let connFd = withUnsafeMutablePointer(to: &clientAddr) { ptr in
        ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            accept(serverFd, $0, &clientLen)
        }
    }

    var buffer = [UInt8](repeating: 0, count: 64)
    var totalBytes = 0
    let expectedBytes = 100_000 * 64
    while totalBytes < expectedBytes {
        let n = recv(connFd, &buffer, buffer.count, 0)
        if n <= 0 {
            break
        }
        totalBytes += n
    }
    clock_gettime(CLOCK_MONOTONIC, &state.end)
    close(connFd)
    close(serverFd)
    sem.signal()
}
serverThread.start()

let clientFd = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
var srvAddr = sockaddr_in()
srvAddr.sin_family = sa_family_t(AF_INET)
srvAddr.sin_port = port
inet_pton(AF_INET, "127.0.0.1", &srvAddr.sin_addr)

_ = withUnsafePointer(to: &srvAddr) { ptr in
    ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        connect(clientFd, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
    }
}

var start = timespec()
clock_gettime(CLOCK_MONOTONIC, &start)

var packet = [UInt8](repeating: 0, count: 64)
for _ in 0..<100_000 {
    var sent = 0
    while sent < 64 {
        let n = send(clientFd, packet.withUnsafeBufferPointer { $0.baseAddress! + sent }, 64 - sent, 0)
        if n <= 0 { break }
        sent += n
    }
}

sem.wait()
close(clientFd)

let elapsedMs = Double(state.end.tv_sec - start.tv_sec) * 1000.0 + Double(state.end.tv_nsec - start.tv_nsec) / 1000000.0
let elapsedS = elapsedMs / 1000.0

print(String(format: "  [Network] Packets: 100000 | Size: 64 B | Time: %.4f ms (%.6f s)", elapsedMs, elapsedS))
