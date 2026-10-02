HC ?= holyc
TARGET = memory_churn

all: build

build: $(TARGET)

$(TARGET): main.HC
	$(HC) -o $(TARGET) main.HC

run: build
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
