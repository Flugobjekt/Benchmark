HC ?= holyc
TARGET = cold_start

all: build

build: $(TARGET)

$(TARGET): main.HC
	$(HC) -o $(TARGET) main.HC

run: build
	./run_cold_start.sh

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
