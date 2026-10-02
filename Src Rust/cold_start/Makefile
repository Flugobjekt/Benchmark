CARGO = cargo

run: build
	./run_cold_start.sh

build:
	RUSTFLAGS="-C target-cpu=native" $(CARGO) build --release

clean:
	$(CARGO) clean

.PHONY: run build clean
