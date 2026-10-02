package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Payload struct {
	Name    string `json:"name"`
	Version int    `json:"version"`
}

func main() {
	input := `{"name":"Speedtest","version":1}`
	var p Payload
	if err := json.Unmarshal([]byte(input), &p); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR: %v\n", err)
		os.Exit(1)
	}
	fmt.Println(p.Name)
}
