DMD ?= $(shell command -v dmd 2>/dev/null || (test -x $(HOME)/.local/bin/dmd && echo $(HOME)/.local/bin/dmd) || echo /home/linuxbrew/.linuxbrew/bin/dmd)
DFLAGS = -O -release -inline -boundscheck=off
TARGET = cold_start

all: build

build: $(TARGET)

$(TARGET): main.d
	$(DMD) $(DFLAGS) -of=$(TARGET) main.d

run: build
	./run_cold_start.sh

clean:
	rm -f $(TARGET) $(TARGET).o

.PHONY: all build run clean
