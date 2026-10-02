CC = gcc
CFLAGS = -O3 -march=native -flto -Wall -Wextra
TARGET = cold_start

all: build

build: $(TARGET)

$(TARGET): main.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c

run: build
	./run_cold_start.sh

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
