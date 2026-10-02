ZIG = zig
ZIGFLAGS = -O ReleaseFast -mcpu=native

TARGET = network

all: build

build: $(TARGET)

$(TARGET): main.zig
	$(ZIG) build-exe $(ZIGFLAGS) main.zig -femit-bin=$(TARGET)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) $(TARGET).o

.PHONY: all build run clean
