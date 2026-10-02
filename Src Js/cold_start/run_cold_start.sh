#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

START=$(date +%s%N)
for i in $(seq 1 1000); do
    bun run index.js > /dev/null
done
END=$(date +%s%N)

ELAPSED_NS=$((END - START))
ELAPSED_MS=$(awk -v ns="$ELAPSED_NS" 'BEGIN { printf "%.4f", ns / 1000000 }')
ELAPSED_S=$(awk -v ns="$ELAPSED_NS" 'BEGIN { printf "%.6f", ns / 1000000000 }')

echo "  [Cold Start] Runs: 1000 | Time: ${ELAPSED_MS} ms (${ELAPSED_S} s)"
