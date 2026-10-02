package main

import (
	"fmt"
	"os"
	"time"
)

type Node struct {
	ID    int
	Value float64
	Name  string
}

func main() {
	start := time.Now()

	nodes := make([]*Node, 5000000)
	for i := 0; i < 5000000; i++ {
		nodes[i] = &Node{
			ID:    i,
			Value: float64(i),
			Name:  "Node",
		}
	}

	for i := 3000000; i < 5000000; i++ {
		nodes[i] = nil
	}
	nodes = nodes[:3000000]

	for i := 0; i < 2000000; i++ {
		nodes = append(nodes, &Node{
			ID:    5000000 + i,
			Value: float64(5000000 + i),
			Name:  "Node",
		})
	}

	elapsed := time.Since(start)

	finalCount := len(nodes)
	if finalCount != 5000000 || nodes[4999999].ID != 6999999 {
		fmt.Fprintf(os.Stderr, "ERROR: Expected 5000000 nodes\n")
		os.Exit(1)
	}

	elapsedMs := float64(elapsed.Nanoseconds()) / 1_000_000.0
	elapsedS := elapsed.Seconds()

	fmt.Printf("  [Memory] Final Nodes: %d | Time: %10.4f ms (%8.6f s)\n",
		finalCount, elapsedMs, elapsedS)
}
