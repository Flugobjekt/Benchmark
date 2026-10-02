SWIFTC ?= $(shell command -v swiftc 2>/dev/null || which swiftc 2>/dev/null || ( [ -x $(HOME)/.local/bin/swiftc ] && echo $(HOME)/.local/bin/swiftc ) || echo /home/linuxbrew/.linuxbrew/bin/swiftc)
SWIFTFLAGS = -O -whole-module-optimization
TARGET = cold_start

all: build

build: $(TARGET)

$(TARGET): main.swift
	$(SWIFTC) $(SWIFTFLAGS) -o $(TARGET) main.swift

run: build
	./run_cold_start.sh

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
