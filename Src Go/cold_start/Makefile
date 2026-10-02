TARGET = cold_start

all: $(TARGET)

build: $(TARGET)

$(TARGET): main.go
	go build -ldflags="-s -w" -o $(TARGET) main.go

run: $(TARGET)
	./run_cold_start.sh

clean:
	rm -f $(TARGET)

.PHONY: all run clean
