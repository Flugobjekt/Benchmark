CC = gcc
CFLAGS = -O3 -march=native -flto -Wall -Wextra
TARGET = prime_sieve

all: build

build: $(TARGET)

$(TARGET): main.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
