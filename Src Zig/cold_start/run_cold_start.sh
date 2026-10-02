#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$DIR/cold_start"

START=$(date +%s%N)
for ((i = 0; i < 1000; i++)); do
    "$BIN" > /dev/null 2>&1
done
END=$(date +%s%N)

ELAPSED_NS=$((END - START))
awk -v ns="$ELAPSED_NS" 'BEGIN {
    ms = ns / 1000000.0
    s = ns / 1000000000.0
    printf "  [Cold-Start] Runs: 1000 | Time: %.4f ms (%.6f s)\n", ms, s
}'
