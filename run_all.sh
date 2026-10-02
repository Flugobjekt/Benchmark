#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================================================="
echo "    COMPREHENSIVE MULTI-LANGUAGE BENCHMARK SUITE (6 BENCHMARKS x 15 LANGUAGES)"
echo "=========================================================================="
echo ""

run_test() {
    local name="$1"
    local dir="$2"
    echo "=========================================================================="
    echo ">>> Running All 6 Benchmarks for: [$name]"
    echo "=========================================================================="
    (cd "$DIR/$dir" && make run)
    echo ""
}

run_test "C"          "Src C"
run_test "C++"        "Src cpp"
run_test "Rust"       "Src Rust"
run_test "Zig"        "Src Zig"
run_test "Go"         "Src Go"
run_test "C#"         "Src C#"
run_test "Java"       "Src Java"
run_test "JavaScript" "Src Js"
run_test "TypeScript" "Src Ts"
run_test "Python"     "Src Py"
run_test "Lua"        "Src Lua"
run_test "Swift"      "Src Swift"
run_test "HolyC"      "Src HolyC"
run_test "Kotlin"     "Src Kotlin"
run_test "Dlang"      "Src Dlang"

echo "=========================================================================="
echo "                       ALL BENCHMARKS COMPLETED"
echo "=========================================================================="
