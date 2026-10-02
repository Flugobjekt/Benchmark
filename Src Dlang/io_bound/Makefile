DMD ?= $(shell command -v dmd 2>/dev/null || (test -x $(HOME)/.local/bin/dmd && echo $(HOME)/.local/bin/dmd) || echo /home/linuxbrew/.linuxbrew/bin/dmd)
DFLAGS = -O -release -inline -boundscheck=off
TARGET = io_bound

all: build

build: $(TARGET)

$(TARGET): main.d
	$(DMD) $(DFLAGS) -of=$(TARGET) main.d

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf $(TARGET) $(TARGET).o tmp_io_test

.PHONY: all build run clean
