CXX = g++
CXXFLAGS = -O3 -march=native -std=c++20 -flto -Wall -Wextra
TARGET = network

all: build

build: $(TARGET)

$(TARGET): main.cpp
	$(CXX) $(CXXFLAGS) -o $(TARGET) main.cpp

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
