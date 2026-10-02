CARGO = cargo

all: build

build:
	RUSTFLAGS="-C target-cpu=native" $(CARGO) build --release

run:
	RUSTFLAGS="-C target-cpu=native" $(CARGO) run --release

clean:
	$(CARGO) clean

.PHONY: all build run clean
