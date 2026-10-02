package main

import (
	"fmt"
	"os"
	"time"
	"unsafe"
)

func runSieve(limit int, expected int) {
	numOdds := limit / 2
	isPrime := make([]byte, numOdds)
	for i := range isPrime {
		isPrime[i] = 1
	}
	if numOdds > 0 {
		isPrime[0] = 0
	}

	ptr := unsafe.Pointer(&isPrime[0])

	start := time.Now()

	for i := 1; (2*i+1)*(2*i+1) < limit; i++ {
		if *(*byte)(unsafe.Add(ptr, i)) != 0 {
			p := 2*i + 1
			j := 2 * i * (i + 1)
			p4 := 4 * p

			for j+p4 <= numOdds {
				*(*byte)(unsafe.Add(ptr, j)) = 0
				*(*byte)(unsafe.Add(ptr, j+p)) = 0
				*(*byte)(unsafe.Add(ptr, j+2*p)) = 0
				*(*byte)(unsafe.Add(ptr, j+3*p)) = 0
				j += p4
			}

			for j < numOdds {
				*(*byte)(unsafe.Add(ptr, j)) = 0
				j += p
			}
		}
	}

	elapsed := time.Since(start)

	primeCount := 1
	for i := 1; i < numOdds; i++ {
		primeCount += int(isPrime[i])
	}

	elapsedMs := float64(elapsed.Nanoseconds()) / 1_000_000.0
	elapsedS := elapsed.Seconds()

	fmt.Printf("  [Sieve]   Limit: %11d | Primes: %9d | Time: %10.4f ms (%8.6f s)\n",
		limit, primeCount, elapsedMs, elapsedS)

	if primeCount != expected {
		fmt.Fprintf(os.Stderr, "ERROR: Expected %d, got %d\n", expected, primeCount)
		os.Exit(1)
	}
}

func main() {
	runSieve(1000000, 78498)
	runSieve(10000000, 664579)
	runSieve(100000000, 5761455)
	runSieve(1000000000, 50847534)
}
