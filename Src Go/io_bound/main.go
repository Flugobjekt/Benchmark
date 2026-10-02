package main

import (
	"bytes"
	"fmt"
	"os"
	"runtime"
	"sync"
	"sync/atomic"
	"time"
)

func main() {
	dir := "./tmp_io_test"
	_ = os.RemoveAll(dir)
	if err := os.MkdirAll(dir, 0755); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(1)
	}

	var genWg sync.WaitGroup
	genWorkers := runtime.NumCPU() * 2
	genJobs := make(chan int, 10000)
	for i := 0; i < 10000; i++ {
		genJobs <- i
	}
	close(genJobs)

	for w := 0; w < genWorkers; w++ {
		genWg.Add(1)
		go func() {
			defer genWg.Done()
			for i := range genJobs {
				path := fmt.Sprintf("%s/file_%d.txt", dir, i)
				var content []byte
				if i%10 == 0 {
					content = []byte("Alpha line\nBenchmark line\nOmega line\n")
				} else {
					content = []byte("Alpha line\nNormal line\nOmega line\n")
				}
				_ = os.WriteFile(path, content, 0644)
			}
		}()
	}
	genWg.Wait()

	start := time.Now()

	var readWg sync.WaitGroup
	readWorkers := runtime.NumCPU() * 2
	readJobs := make(chan int, 10000)
	for i := 0; i < 10000; i++ {
		readJobs <- i
	}
	close(readJobs)

	var matches int64
	for w := 0; w < readWorkers; w++ {
		readWg.Add(1)
		go func() {
			defer readWg.Done()
			for i := range readJobs {
				path := fmt.Sprintf("%s/file_%d.txt", dir, i)
				data, err := os.ReadFile(path)
				if err == nil && bytes.Contains(data, []byte("Benchmark")) {
					atomic.AddInt64(&matches, 1)
				}
			}
		}()
	}
	readWg.Wait()

	elapsed := time.Since(start)

	_ = os.RemoveAll(dir)

	elapsedMs := float64(elapsed.Nanoseconds()) / 1_000_000.0
	elapsedS := elapsed.Seconds()

	fmt.Printf("  [IO-Bound] Files: 10000 | Matches: %4d | Time: %10.4f ms (%8.6f s)\n",
		matches, elapsedMs, elapsedS)

	if matches != 1000 {
		fmt.Fprintf(os.Stderr, "ERROR: Expected 1000 matches, got %d\n", matches)
		os.Exit(1)
	}
}
