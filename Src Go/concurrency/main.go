package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {
	var wg sync.WaitGroup
	wg.Add(500)

	start := time.Now()

	for i := 0; i < 500; i++ {
		go func() {
			defer wg.Done()
			time.Sleep(200 * time.Millisecond)
		}()
	}

	wg.Wait()
	elapsed := time.Since(start)

	elapsedMs := float64(elapsed.Nanoseconds()) / 1_000_000.0
	elapsedS := elapsed.Seconds()

	fmt.Printf("  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: %10.4f ms (%8.6f s)\n",
		elapsedMs, elapsedS)
}
