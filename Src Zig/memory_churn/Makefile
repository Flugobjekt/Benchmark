ZIG = zig
ZIGFLAGS = -O ReleaseFast -mcpu=native -lc

run:
	$(ZIG) run $(ZIGFLAGS) main.zig

clean:
	rm -rf .zig-cache

.PHONY: run clean
