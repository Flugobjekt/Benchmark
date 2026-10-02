#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
JAVA="${JAVA:-java}"

START=$(date +%s%N)
for _ in $(seq 1 1000); do
    "$JAVA" -cp "$DIR" Main > /dev/null
done
END=$(date +%s%N)

ELAPSED_NS=$((END - START))
ELAPSED_MS=$(awk "BEGIN {printf \"%.4f\", $ELAPSED_NS / 1000000}")
ELAPSED_S=$(awk "BEGIN {printf \"%.6f\", $ELAPSED_NS / 1000000000}")

printf "  [Cold-Start] Runs: 1000 | Time: %s ms (%s s)\n" "$ELAPSED_MS" "$ELAPSED_S"
