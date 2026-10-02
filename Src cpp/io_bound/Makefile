CXX = g++
CXXFLAGS = -O3 -march=native -std=c++20 -flto -Wall -Wextra
TARGET = io_bound

all: build

build: $(TARGET)

$(TARGET): main.cpp
	$(CXX) $(CXXFLAGS) -o $(TARGET) main.cpp

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(TARGET) tmp_io_test

.PHONY: all build run clean
