HC ?= holyc
TARGET = loop_counter

all: build

build: $(TARGET)

$(TARGET): main.HC
	$(HC) -o $(TARGET) main.HC

run: build
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
