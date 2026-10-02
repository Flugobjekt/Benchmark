HC ?= holyc
TARGET = io_bound

all: build

build: $(TARGET)

$(TARGET): main.HC
	$(HC) -o $(TARGET) main.HC

run: build
	./$(TARGET)

clean:
	rm -f $(TARGET)
	rm -rf ./tmp_io_test

.PHONY: all build run clean
