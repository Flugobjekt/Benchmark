ZIG = zig
ZIGFLAGS = -O ReleaseFast -mcpu=native

TARGET = cold_start

all: $(TARGET)

$(TARGET): main.zig
	$(ZIG) build-exe $(ZIGFLAGS) main.zig -femit-bin=$(TARGET)

run: $(TARGET)
	./run_cold_start.sh

clean:
	rm -f $(TARGET) $(TARGET).o

.PHONY: all $(TARGET) run clean
