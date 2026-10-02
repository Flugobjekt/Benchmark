# Comprehensive Multi-Language Performance Benchmark Suite

A modular, cross-language benchmark suite evaluating **15 programming languages** across **7 distinct performance domains**, from low-level CPU arithmetic and memory bandwidth to asynchronous I/O, network packet processing, and process startup latencies.

Every language is organized into dedicated subdirectories with individual Makefiles for each benchmark.

---

## Languages & Official Resources

Official repositories, homepages, and documentation links for all 15 benchmarked languages:

| Language | Official Website | Repository / Source | Official Documentation |
| :--- | :--- | :--- | :--- |
| **C** | [iso-9899.info](https://www.iso-9899.info/) | [GCC Git](https://gcc.gnu.org/git/gcc.git) / [LLVM Project](https://github.com/llvm/llvm-project) | [cppreference (C)](https://en.cppreference.com/w/c) |
| **C#** | [dotnet.microsoft.com](https://dotnet.microsoft.com/) | [github.com/dotnet/runtime](https://github.com/dotnet/runtime) | [learn.microsoft.com/dotnet/csharp](https://learn.microsoft.com/dotnet/csharp/) |
| **C++** | [isocpp.org](https://isocpp.org/) | [GCC Git](https://gcc.gnu.org/git/gcc.git) / [LLVM Project](https://github.com/llvm/llvm-project) | [cppreference (C++)](https://en.cppreference.com/w/cpp) |
| **Dlang** | [dlang.org](https://dlang.org/) | [github.com/dlang/dmd](https://github.com/dlang/dmd) | [dlang.org/spec](https://dlang.org/spec/spec.html) |
| **Go** | [go.dev](https://go.dev/) | [github.com/golang/go](https://github.com/golang/go) | [go.dev/doc](https://go.dev/doc/) |
| **HolyC** | [holyc-lang.com](https://holyc-lang.com/) | [github.com/Jamesbarford/holyc-lang](https://github.com/Jamesbarford/holyc-lang) | [holyc-lang.com/docs](https://holyc-lang.com/docs/intro) |
| **Java** | [openjdk.org](https://openjdk.org/) | [github.com/openjdk/jdk](https://github.com/openjdk/jdk) | [docs.oracle.com/en/java](https://docs.oracle.com/en/java/) |
| **JavaScript** | [bun.sh](https://bun.sh/) | [github.com/oven-sh/bun](https://github.com/oven-sh/bun) | [bun.sh/docs](https://bun.sh/docs) |
| **Kotlin** | [kotlinlang.org](https://kotlinlang.org/) | [github.com/JetBrains/kotlin](https://github.com/JetBrains/kotlin) | [kotlinlang.org/docs](https://kotlinlang.org/docs/home.html) |
| **Lua** | [luajit.org](https://luajit.org/) | [github.com/LuaJIT/LuaJIT](https://github.com/LuaJIT/LuaJIT) | [luajit.org/ext_ffi.html](https://luajit.org/ext_ffi.html) |
| **Python** | [python.org](https://www.python.org/) | [github.com/python/cpython](https://github.com/python/cpython) | [docs.python.org/3](https://docs.python.org/3/) |
| **Rust** | [rust-lang.org](https://www.rust-lang.org/) | [github.com/rust-lang/rust](https://github.com/rust-lang/rust) | [doc.rust-lang.org](https://doc.rust-lang.org/) |
| **Swift** | [swift.org](https://www.swift.org/) | [github.com/swiftlang/swift](https://github.com/swiftlang/swift) | [swift.org/documentation](https://swift.org/documentation/) |
| **TypeScript** | [typescriptlang.org](https://www.typescriptlang.org/) | [github.com/microsoft/TypeScript](https://github.com/microsoft/TypeScript) | [typescriptlang.org/docs](https://typescriptlang.org/docs/) |
| **Zig** | [ziglang.org](https://ziglang.org/) | [github.com/ziglang/zig](https://github.com/ziglang/zig) | [ziglang.org/documentation](https://ziglang.org/documentation/) |

---

## Benchmark Results (All 7 Suites)

All tables list languages in alphabetical order. The top 3 fastest overall and top 3 per category are detailed below each table.

---

### 1. Prime Sieve Benchmark (Sieve of Eratosthenes)

Tests memory access, bit/byte operations, and cache hierarchy scaling from 1 Million to 1 Billion.

| Language | Runtime / Compiler | 1,000,000 (1M)<br>$\pi(N)=78,498$ | 10,000,000 (10M)<br>$\pi(N)=664,579$ | 100,000,000 (100M)<br>$\pi(N)=5,761,455$ | 1,000,000,000 (1B)<br>$\pi(N)=50,847,534$ |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **C** | GCC 16.2.1 (`-O3 -march=native -flto`) | 0.266 ms | 3.326 ms | 287.92 ms | 3,667.73 ms |
| **C#** | .NET 10.0 LTS (RyuJIT Tiered PGO) | 7.398 ms | 3.416 ms | 318.86 ms | 3,895.98 ms |
| **C++** | G++ 16.2.1 (`-O3 -march=native -std=c++20 -flto`) | 0.285 ms | 3.444 ms | 336.07 ms | 4,001.61 ms |
| **Dlang** | DMD 2.113.0 (`-O -release -inline -boundscheck=off`) | 0.271 ms | 3.338 ms | 309.31 ms | 3,603.49 ms |
| **Go** | Go 1.27.1 (`unsafe.Pointer`) | 0.265 ms | 3.352 ms | 283.33 ms | 3,785.10 ms |
| **HolyC** | HolyC Compiler `hcc` (Native ELF) | 0.922 ms | 11.11 ms | 363.67 ms | 4,449.57 ms |
| **Java** | OpenJDK 27 (HotSpot C2 JIT) | 3.627 ms | 4.821 ms | 316.87 ms | 3,947.01 ms |
| **JavaScript** | Bun 1.4.2 (JavaScriptCore JIT) | 1.916 ms | 7.635 ms | 303.71 ms | 3,786.29 ms |
| **Kotlin** | Kotlin 2.4.20 (JRE 27) | 3.091 ms | 5.133 ms | 284.77 ms | 3,632.00 ms |
| **Lua** | LuaJIT 2.1 (FFI Array) | 0.442 ms | 3.376 ms | 285.70 ms | 3,629.61 ms |
| **Python** | CPython 3.14.7 + uv 0.12 | 0.852 ms | 9.316 ms | 355.40 ms | 4,535.28 ms |
| **Rust** | Rustc 1.99.0 (`opt-level = 3`, Fat LTO) | 0.261 ms | 3.505 ms | 302.27 ms | 3,900.20 ms |
| **Swift** | Swift 6.4.0 (`-O -whole-module-optimization`) | 0.263 ms | 3.646 ms | 301.35 ms | 3,632.53 ms |
| **TypeScript** | Bun 1.4.2 (Native TS Runner) | 2.013 ms | 7.705 ms | 303.88 ms | 3,871.84 ms |
| **Zig** | Zig 0.16.0 (`-O ReleaseFast -mcpu=native`) | 0.278 ms | 3.385 ms | 301.88 ms | 3,801.28 ms |

#### Rankings & Highlights

- **Top 3 Fastest Overall (Cumulative Across All Limits)**:
  1. **Dlang** (Total: 3,916.41 ms)
  2. **Lua** (Total: 3,919.13 ms)
  3. **Kotlin** (Total: 3,924.99 ms)
  *(Followed by Swift: 3,937.79 ms and C: 3,959.24 ms)*

- **Top 3 per Category**:
  - **1 Million (1M)**: 1. Rust (0.261 ms), 2. Swift (0.263 ms), 3. Go (0.265 ms)
  - **10 Million (10M)**: 1. C (3.326 ms), 2. Dlang (3.338 ms), 3. Go (3.352 ms)
  - **100 Million (100M)**: 1. Go (283.33 ms), 2. Kotlin (284.77 ms), 3. Lua (285.70 ms)
  - **1 Billion (1B)**: 1. Dlang (3,603.49 ms), 2. Lua (3,629.61 ms), 3. Kotlin (3,632.00 ms)

---

### 2. Loop Counter Benchmark (Sequential Increment Loop)

Tests raw CPU arithmetic, register increment throughput, and loop branch prediction.

| Language | Runtime / Compiler | 1,000,000 (1M) | 10,000,000 (10M) | 100,000,000 (100M) | 1,000,000,000 (1B) |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **C** | GCC 16.2.1 | 0.224 ms | 2.251 ms | 22.68 ms | 224.70 ms |
| **C#** | .NET 10.0 LTS | 4.807 ms | 2.393 ms | 23.12 ms | 229.97 ms |
| **C++** | G++ 16.2.1 | 0.241 ms | 2.357 ms | 24.41 ms | 235.25 ms |
| **Dlang** | DMD 2.113.0 | 0.226 ms | 2.296 ms | 22.71 ms | 229.50 ms |
| **Go** | Go 1.27.1 | 0.236 ms | 2.287 ms | 23.06 ms | 227.75 ms |
| **HolyC** | HolyC Compiler `hcc` | 0.476 ms | 5.266 ms | 46.07 ms | 453.25 ms |
| **Java** | OpenJDK 27 | 2.978 ms | 8.025 ms | 42.12 ms | 349.02 ms |
| **JavaScript** | Bun 1.4.2 | 1.699 ms | 3.972 ms | 34.07 ms | 340.07 ms |
| **Kotlin** | Kotlin 2.4.20 (JRE 27) | 2.852 ms | 7.118 ms | 40.43 ms | 406.73 ms |
| **Lua** | LuaJIT 2.1 | 0.704 ms | 6.781 ms | 68.28 ms | 672.13 ms |
| **Python** | CPython 3.14.7 + uv 0.12 | 31.10 ms | 280.91 ms | 2,903.06 ms | 28,365.78 ms |
| **Rust** | Rustc 1.99.0 | 0.450 ms | 12.15 ms | 117.75 ms | 581.35 ms |
| **Swift** | Swift 6.4.0 | 0.225 ms | 2.299 ms | 22.65 ms | 228.02 ms |
| **TypeScript** | Bun 1.4.2 | 1.453 ms | 3.782 ms | 34.46 ms | 341.86 ms |
| **Zig** | Zig 0.16.0 | 0.236 ms | 2.310 ms | 30.63 ms | 473.93 ms |

#### Rankings & Highlights

- **Top 3 Fastest Overall (Cumulative Across All Limits)**:
  1. **C** (Total: 249.86 ms)
  2. **Swift** (Total: 253.19 ms)
  3. **Go** (Total: 253.33 ms)
  *(Followed by Dlang: 254.73 ms and C#: 260.29 ms)*

- **Top 3 per Category**:
  - **1 Million (1M)**: 1. C (0.224 ms), 2. Swift (0.225 ms), 3. Dlang (0.226 ms)
  - **10 Million (10M)**: 1. C (2.251 ms), 2. Go (2.287 ms), 3. Dlang (2.296 ms)
  - **100 Million (100M)**: 1. Swift (22.65 ms), 2. C (22.68 ms), 3. Dlang (22.71 ms)
  - **1 Billion (1B)**: 1. C (224.70 ms), 2. Go (227.75 ms), 3. Swift (228.02 ms)

---

### 3. I/O-Bound Benchmark (Read & search 10,000 files)

Tests OS kernel interaction, filesystem throughput, buffer management, and thread pooling across 10,000 generated files.

| Language | Runtime / Mechanism | Read & Search Duration |
| :--- | :--- | :---: |
| **C** | Pooled buffered reads | 13.96 ms |
| **C#** | `Parallel.For` multi-threaded file streams | 37.49 ms |
| **C++** | Buffered stream search | 15.50 ms |
| **Dlang** | `std.parallelism` task pool | 21.26 ms |
| **Go** | Concurrent worker pool (`runtime.NumCPU() * 2`) | 19.61 ms |
| **HolyC** | Native buffered file search | 66.99 ms |
| **Java** | Virtual Threads `Thread.ofVirtual()` executor | 85.72 ms |
| **JavaScript** | Asynchronous `Bun.file` promises | 23.68 ms |
| **Kotlin** | Virtual Threads executor | 103.80 ms |
| **Lua** | `io.open` buffered search | 67.48 ms |
| **Python** | `concurrent.futures.ThreadPoolExecutor` | 403.24 ms |
| **Rust** | Parallel `std::thread` batch processing | 79.49 ms |
| **Swift** | Concurrent task groups + buffered streams | 17.61 ms |
| **TypeScript** | Asynchronous `Bun.file` promises | 24.60 ms |
| **Zig** | Multi-threaded file descriptor reader | 59.21 ms |

#### Rankings & Highlights

- **Top 3 Fastest Overall**:
  1. **C** — **13.96 ms**
  2. **C++** — **15.50 ms**
  3. **Swift** — **17.61 ms**
  *(Followed by Go: 19.61 ms and Dlang: 21.26 ms)*

---

### 4. Concurrency Benchmark (500 parallel tasks with 200 ms latency)

Tests scheduler overhead, thread context switching, and non-blocking event loops under 500 concurrent tasks.

| Language | Concurrency Primitive | Total Duration (Target: ~200 ms) |
| :--- | :--- | :---: |
| **C** | 500 POSIX Threads (`pthread_create`) | 210.18 ms |
| **C#** | 500 `Task.Delay` with `Task.WhenAll` | 204.86 ms |
| **C++** | 500 `std::jthread` / `std::thread` | 210.51 ms |
| **Dlang** | 500 OS Threads (`core.thread.osthread`) | 218.00 ms |
| **Go** | 500 Goroutines (`sync.WaitGroup`) | 200.77 ms |
| **HolyC** | 500 POSIX Threads (`pthread_create`) | 209.77 ms |
| **Java** | 500 Virtual Threads (`Executors.newVirtualThreadPerTaskExecutor`) | 216.08 ms |
| **JavaScript** | `Promise.all` + event loop timer | 200.72 ms |
| **Kotlin** | 500 Virtual Threads | 221.34 ms |
| **Lua** | Coroutines event loop scheduler | 200.79 ms |
| **Python** | `asyncio.gather` coroutines | 204.39 ms |
| **Rust** | 500 OS Threads (`std::thread::scope`) | 211.50 ms |
| **Swift** | 500 `TaskGroup` asynchronous tasks | 201.36 ms |
| **TypeScript** | `Promise.all` + event loop timer | 200.83 ms |
| **Zig** | 500 Native Threads (`std.Thread`) | 294.64 ms |

#### Rankings & Highlights

- **Top 3 Fastest Overall (Minimal Scheduling Overhead above 200 ms)**:
  1. **JavaScript** — **200.72 ms** (+0.72 ms overhead)
  2. **Go** — **200.77 ms** (+0.77 ms overhead)
  3. **Lua** — **200.79 ms** (+0.79 ms overhead)
  *(Followed by TypeScript: 200.83 ms and Swift: 201.36 ms)*

---

### 5. Memory & Garbage Collection Churn Benchmark (5M nodes + 2M churn)

Tests heap allocation speed, pointer chasing, memory reclamation, and GC pause times under high allocation pressure.

| Language | Memory Management Mechanism | Duration |
| :--- | :--- | :---: |
| **C** | Manual `free` / `malloc` (ptmalloc) | 577.40 ms |
| **C#** | .NET 10 Generational GC | 515.03 ms |
| **C++** | Manual `delete` / `new` (ptmalloc) | 351.04 ms |
| **Dlang** | D Garbage Collector | 651.35 ms |
| **Go** | Go Concurrent Tri-color GC | 221.25 ms |
| **HolyC** | `Free` / `MAlloc` | 640.91 ms |
| **Java** | OpenJDK 27 Generational ZGC / G1 | 151.28 ms |
| **JavaScript** | JavaScriptCore Generational GC | 595.03 ms |
| **Kotlin** | OpenJDK 27 Generational ZGC / G1 | 149.72 ms |
| **Lua** | LuaJIT FFI struct array / GC | 669.42 ms |
| **Python** | CPython Reference Counting + Cyclic GC | 3,223.28 ms |
| **Rust** | Deterministic RAII / allocator | 262.44 ms |
| **Swift** | Automatic Reference Counting (ARC) / Allocator | 84.57 ms |
| **TypeScript** | JavaScriptCore Generational GC | 581.64 ms |
| **Zig** | C Allocator `c_allocator` | 299.30 ms |

#### Rankings & Highlights

- **Top 3 Fastest Overall (Heap Management Throughput)**:
  1. **Swift** — **84.57 ms**
  2. **Kotlin** — **149.72 ms**
  3. **Java** — **151.28 ms**
  *(Followed by Go: 221.25 ms and Rust: 262.44 ms)*

---

### 6. Cold-Start Latency Benchmark (1,000 process starts parsing JSON)

Measures binary initialization overhead, runtime boot latency, dynamic linker resolution, and basic JSON parsing across 1,000 external process calls.

| Language | Runtime / Binary Format | 1,000 Process Invocations | Per-Start Latency |
| :--- | :--- | :---: | :---: |
| **C** | Native compiled ELF | 720.24 ms | ~0.72 ms |
| **C#** | .NET 10 Native AOT binary | 4,229.00 ms | ~4.23 ms |
| **C++** | Native compiled ELF | 1,447.50 ms | ~1.45 ms |
| **Dlang** | Native compiled ELF (with D runtime) | 1,588.68 ms | ~1.59 ms |
| **Go** | Native compiled ELF (with Go runtime) | 1,494.91 ms | ~1.49 ms |
| **HolyC** | Native compiled ELF (`hcc`) | 787.50 ms | ~0.79 ms |
| **Java** | OpenJDK 27 JVM HotSpot | 23,725.68 ms | ~23.73 ms |
| **JavaScript** | Bun JIT / Runtime | 4,871.64 ms | ~4.87 ms |
| **Kotlin** | Precompiled JAR on OpenJDK 27 | 40,413.67 ms | ~40.41 ms |
| **Lua** | LuaJIT Bytecode interpreter | 985.54 ms | ~0.99 ms |
| **Python** | CPython 3.14 Interpreter | 19,885.47 ms | ~19.89 ms |
| **Rust** | Native compiled ELF | 881.86 ms | ~0.88 ms |
| **Swift** | Native compiled ELF (with Swift runtime) | 7,873.94 ms | ~7.87 ms |
| **TypeScript** | Bun JIT / Runtime | 4,780.26 ms | ~4.78 ms |
| **Zig** | Native compiled ELF | 894.65 ms | ~0.89 ms |

#### Rankings & Highlights

- **Top 3 Fastest Overall (Lowest Startup Latency)**:
  1. **C** — **720.24 ms** (~0.72 ms per process start)
  2. **HolyC** — **787.50 ms** (~0.79 ms per process start)
  3. **Rust** — **881.86 ms** (~0.88 ms per process start)
  *(Followed by Zig: ~0.89 ms and Lua: ~0.99 ms)*

---

### 7. Network & Packet Processing Benchmark (100,000 TCP Packets)

Tests socket syscall throughput, packet framing, buffer copies, and kernel TCP network stack turnaround by streaming **100,000 binary packets of 64 bytes (6.4 MB total)** across local loopback (`127.0.0.1`).

| Language | Runtime / Network API | Duration (100,000 Packets) | Packet Processing Rate |
| :--- | :--- | :---: | :---: |
| **C** | POSIX Sockets (`sys/socket.h`) | 2.30 ms | ~43.4M pkts/s (~2.78 GB/s) |
| **C#** | `System.Net.Sockets.Socket` | 162.08 ms | ~617k pkts/s (~39.5 MB/s) |
| **C++** | POSIX Sockets (`<sys/socket.h>`) | 2.60 ms | ~38.5M pkts/s (~2.46 GB/s) |
| **Dlang** | `std.socket.TcpSocket` | 81.45 ms | ~1.23M pkts/s (~78.6 MB/s) |
| **Go** | `net.TCPConn` / `net.Listen` | 569.02 ms | ~175k pkts/s (~11.2 MB/s) |
| **HolyC** | POSIX Sockets (`tos.HH`) | 78.61 ms | ~1.27M pkts/s (~81.4 MB/s) |
| **Java** | `java.net.Socket` / `ServerSocket` | 211.83 ms | ~472k pkts/s (~30.2 MB/s) |
| **JavaScript** | Bun `node:net` | 81.45 ms | ~1.23M pkts/s (~78.6 MB/s) |
| **Kotlin** | `java.net.Socket` / `ServerSocket` | 119.31 ms | ~838k pkts/s (~53.6 MB/s) |
| **Lua** | LuaJIT FFI POSIX Sockets | 126.14 ms | ~792k pkts/s (~50.7 MB/s) |
| **Python** | Python `socket.socket` | 150.82 ms | ~663k pkts/s (~42.4 MB/s) |
| **Rust** | `std::net::TcpStream` / `TcpListener` | 1.95 ms | ~51.3M pkts/s (~3.28 GB/s) |
| **Swift** | Swift POSIX Sockets / Foundation | 77.48 ms | ~1.29M pkts/s (~82.6 MB/s) |
| **TypeScript** | Bun `node:net` | 93.12 ms | ~1.07M pkts/s (~68.7 MB/s) |
| **Zig** | `std.posix.system` Sockets | 2.39 ms | ~41.8M pkts/s (~2.68 GB/s) |

#### Rankings & Highlights

- **Top 3 Fastest Overall (TCP Packet Processing Throughput)**:
  1. **Rust** — **1.95 ms** (~51.3 Million packets/s / 3.28 GB/s)
  2. **C** — **2.30 ms** (~43.4 Million packets/s / 2.78 GB/s)
  3. **Zig** — **2.39 ms** (~41.8 Million packets/s / 2.68 GB/s)
  *(Followed by C++: 2.60 ms)*

---

## Directory Organization

Each language folder contains 7 dedicated benchmark subdirectories:

```
Speedtest/
├── Src <Language>/
│   ├── Makefile          # Runs all 7 subdirectories
│   ├── prime_sieve/      # Sieve of Eratosthenes (1M, 10M, 100M, 1B)
│   ├── loop_counter/     # Arithmetic loop counter (1M, 10M, 100M, 1B)
│   ├── io_bound/         # 10,000 file search
│   ├── concurrency/      # 500 parallel tasks with 200 ms latency
│   ├── memory_churn/     # 5M nodes memory allocation churn
│   ├── cold_start/       # JSON parser + 1,000 run loop
│   └── network/          # TCP socket 100k packet streaming
```

---

## How to Run

### Run everything (all 105 benchmarks across 15 languages)

```sh
cd /var/home/flieger/Code/Speedtest
make run
# or directly:
./run_all.sh
```

### Run an individual language suite

```sh
cd "Src C" && make run
cd "Src cpp" && make run
cd "Src Rust" && make run
cd "Src Zig" && make run
cd "Src Go" && make run
cd "Src C#" && make run
cd "Src Java" && make run
cd "Src Js" && make run
cd "Src Ts" && make run
cd "Src Py" && make run
cd "Src Lua" && make run
cd "Src Swift" && make run
cd "Src HolyC" && make run
cd "Src Kotlin" && make run
cd "Src Dlang" && make run
```

### Clean build artifacts across all 15 languages

```sh
make clean
```
