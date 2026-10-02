#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JAVA="${JAVA:-java}"
JAR="$DIR/cold_start.jar"

START=$(date +%s%N)
for ((i = 0; i < 1000; i++)); do
    "$JAVA" -jar "$JAR" > /dev/null
done
END=$(date +%s%N)

ELAPSED_NS=$((END - START))
awk -v ns="$ELAPSED_NS" 'BEGIN {
    ms = ns / 1000000.0
    s = ns / 1000000000.0
    printf "  [Cold-Start] Runs: 1000 | Time: %.4f ms (%.6f s)\n", ms, s
}'
