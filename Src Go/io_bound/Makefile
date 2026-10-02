TARGET = io_bound

all: $(TARGET)

build: $(TARGET)

$(TARGET): main.go
	go build -ldflags="-s -w" -o $(TARGET) main.go

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
	rm -rf tmp_io_test

.PHONY: all run clean
