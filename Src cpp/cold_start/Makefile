CXX = g++
CXXFLAGS = -O3 -march=native -std=c++20 -flto -Wall -Wextra
TARGET = cold_start

all: build

build: $(TARGET)

$(TARGET): main.cpp
	$(CXX) $(CXXFLAGS) -o $(TARGET) main.cpp

run: build
	./run_cold_start.sh

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
