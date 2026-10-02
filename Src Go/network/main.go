package main

import (
	"fmt"
	"io"
	"net"
	"os"
	"sync"
	"time"
)

func main() {
	packetCount := 100000
	packetSize := 64
	totalBytes := packetCount * packetSize

	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Listen error: %v\n", err)
		os.Exit(1)
	}
	defer listener.Close()

	var wg sync.WaitGroup
	wg.Add(1)

	var serverEndTime time.Time

	go func() {
		defer wg.Done()
		conn, err := listener.Accept()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Accept error: %v\n", err)
			os.Exit(1)
		}
		defer conn.Close()

		buf := make([]byte, 65536)
		received := 0
		for received < totalBytes {
			n, err := conn.Read(buf)
			if n > 0 {
				received += n
			}
			if err != nil {
				if err != io.EOF || received < totalBytes {
					fmt.Fprintf(os.Stderr, "Read error: %v\n", err)
					os.Exit(1)
				}
				break
			}
		}
		serverEndTime = time.Now()
	}()

	conn, err := net.Dial("tcp", listener.Addr().String())
	if err != nil {
		fmt.Fprintf(os.Stderr, "Dial error: %v\n", err)
		os.Exit(1)
	}
	defer conn.Close()

	packet := make([]byte, packetSize)

	start := time.Now()

	for i := 0; i < packetCount; i++ {
		written := 0
		for written < packetSize {
			n, err := conn.Write(packet[written:])
			if err != nil {
				fmt.Fprintf(os.Stderr, "Write error: %v\n", err)
				os.Exit(1)
			}
			written += n
		}
	}

	wg.Wait()

	elapsed := serverEndTime.Sub(start)
	elapsedMs := float64(elapsed.Nanoseconds()) / 1_000_000.0
	elapsedS := elapsed.Seconds()

	fmt.Printf("  [Network] Packets: 100000 | Size: 64 B | Time: %.4f ms (%.6f s)\n",
		elapsedMs, elapsedS)
}
