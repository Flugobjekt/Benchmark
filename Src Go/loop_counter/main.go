package main

import (
	"fmt"
	"os"
	"time"
)

var sink uint64

func runCounter(limit uint64) {
	start := time.Now()

	count := uint64(0)
	for i := uint64(1); i <= limit; i++ {
		count++
	}

	elapsed := time.Since(start)

	sink = count

	elapsedMs := float64(elapsed.Nanoseconds()) / 1_000_000.0
	elapsedS := elapsed.Seconds()

	fmt.Printf("  [Counter] Limit: %11d | Count:  %9d | Time: %10.4f ms (%8.6f s)\n",
		limit, count, elapsedMs, elapsedS)

	if count != limit {
		fmt.Fprintf(os.Stderr, "ERROR: Expected %d, got %d\n", limit, count)
		os.Exit(1)
	}
}

func main() {
	runCounter(1000000)
	runCounter(10000000)
	runCounter(100000000)
	runCounter(1000000000)
}
