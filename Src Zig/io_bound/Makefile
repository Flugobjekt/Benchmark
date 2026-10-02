ZIG = zig
ZIGFLAGS = -O ReleaseFast -mcpu=native

TARGET = io_bound

all: $(TARGET)

$(TARGET): main.zig
	$(ZIG) build-exe $(ZIGFLAGS) main.zig -femit-bin=$(TARGET)

run:
	$(ZIG) run $(ZIGFLAGS) main.zig

clean:
	rm -f $(TARGET) $(TARGET).o
	rm -rf tmp_io_test

.PHONY: all run clean
