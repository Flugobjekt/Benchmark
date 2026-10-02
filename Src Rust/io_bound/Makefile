CARGO = cargo

run:
	RUSTFLAGS="-C target-cpu=native" $(CARGO) run --release

clean:
	$(CARGO) clean
	rm -rf tmp_io_test

.PHONY: run clean
