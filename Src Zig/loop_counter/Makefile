ZIG = zig
ZIGFLAGS = -O ReleaseFast -mcpu=native

TARGET = loop_counter

all: $(TARGET)

$(TARGET): main.zig
	$(ZIG) build-exe $(ZIGFLAGS) main.zig -femit-bin=$(TARGET)

run:
	$(ZIG) run $(ZIGFLAGS) main.zig

clean:
	rm -f $(TARGET) $(TARGET).o

.PHONY: all run clean
