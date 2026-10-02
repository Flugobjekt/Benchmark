SUBDIRS = prime_sieve loop_counter io_bound concurrency memory_churn cold_start network

all: run

run:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir --no-print-directory run; \
	done

clean:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir --no-print-directory clean; \
	done

.PHONY: all run clean
