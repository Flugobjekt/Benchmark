# Execution Guide: Multi-Benchmark Suite

This guide explains how to run any of the 7 benchmarks across all **15 supported languages**.

---

## 1. Quick Start: Run Everything

To run all 7 benchmarks across all 15 languages:

```sh
cd /var/home/flieger/Code/Speedtest
make run
# or
./run_all.sh
```

---

## 2. Supported Languages (15 Languages)

| Directory | Language | Compiler / Runtime |
| :--- | :--- | :--- |
| `Src C` | C | GCC 16.2.1 |
| `Src cpp` | C++ | G++ 16.2.1 |
| `Src Rust` | Rust | Rustc 1.99.0 |
| `Src Zig` | Zig | Zig 0.16.0 |
| `Src Go` | Go | Go 1.27.1 |
| `Src C#` | C# | .NET 10.0 LTS |
| `Src Java` | Java | OpenJDK 27 |
| `Src Js` | JavaScript | Bun 1.4.2 |
| `Src Ts` | TypeScript | Bun 1.4.2 |
| `Src Py` | Python | CPython 3.14.7 via uv |
| `Src Lua` | Lua | LuaJIT 2.1 |
| `Src Swift` | Swift | Swift 6.4.0 |
| `Src HolyC` | HolyC | HolyC Compiler `hcc` |
| `Src Kotlin` | Kotlin | Kotlin 2.4.20 on OpenJDK 27 |
| `Src Dlang` | Dlang | DMD 2.113.0 |

---

## 3. Running an Entire Language Suite

Enter any language directory and run `make run`:

```sh
# Kotlin
cd "Src Kotlin" && make run

# Dlang
cd "Src Dlang" && make run

# Lua
cd "Src Lua" && make run

# Swift
cd "Src Swift" && make run

# HolyC
cd "Src HolyC" && make run

# C
cd "Src C" && make run

# C++
cd "Src cpp" && make run

# Rust
cd "Src Rust" && make run

# Zig
cd "Src Zig" && make run

# Go
cd "Src Go" && make run

# C#
cd "Src C#" && make run

# Java
cd "Src Java" && make run

# JavaScript
cd "Src Js" && make run

# TypeScript
cd "Src Ts" && make run

# Python
cd "Src Py" && make run
```

---

## 4. Running a Specific Benchmark Folder

Every language has 7 benchmark subdirectories:
- `prime_sieve`
- `loop_counter`
- `io_bound`
- `concurrency`
- `memory_churn`
- `cold_start`
- `network`

You can run any individual benchmark folder directly:

```sh
# Rust Network Benchmark
cd "Src Rust/network" && make run

# C Network Benchmark
cd "Src C/network" && make run

# Dlang Prime Sieve
cd "Src Dlang/prime_sieve" && make run

# Kotlin Memory Churn
cd "Src Kotlin/memory_churn" && make run

# Swift Concurrency
cd "Src Swift/concurrency" && make run

# Lua Loop Counter
cd "Src Lua/loop_counter" && make run

# Go I/O-Bound
cd "Src Go/io_bound" && make run

# C Cold-Start
cd "Src C/cold_start" && make run
```

---

## 5. Cleaning Build Artifacts

To remove all compiled binaries and temporary artifacts across all 15 languages:

```sh
cd /var/home/flieger/Code/Speedtest
make clean
```
