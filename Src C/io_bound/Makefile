CC = gcc
CFLAGS = -O3 -march=native -flto -Wall -Wextra
TARGET = io_bound

all: build

build: $(TARGET)

$(TARGET): main.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(TARGET) tmp_io_test

.PHONY: all build run clean
