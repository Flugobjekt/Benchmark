SWIFTC ?= $(shell command -v swiftc 2>/dev/null || which swiftc 2>/dev/null || ( [ -x $(HOME)/.local/bin/swiftc ] && echo $(HOME)/.local/bin/swiftc ) || echo /home/linuxbrew/.linuxbrew/bin/swiftc)
SWIFTFLAGS = -O -whole-module-optimization
TARGET = network

all: build

build: $(TARGET)

$(TARGET): main.swift
	$(SWIFTC) $(SWIFTFLAGS) -o $(TARGET) main.swift

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
