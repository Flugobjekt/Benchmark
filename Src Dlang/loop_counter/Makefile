DMD ?= $(shell command -v dmd 2>/dev/null || (test -x $(HOME)/.local/bin/dmd && echo $(HOME)/.local/bin/dmd) || echo /home/linuxbrew/.linuxbrew/bin/dmd)
DFLAGS = -O -release -inline -boundscheck=off
TARGET = loop_counter

all: build

build: $(TARGET)

$(TARGET): main.d
	$(DMD) $(DFLAGS) -of=$(TARGET) main.d

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) $(TARGET).o

.PHONY: all build run clean
