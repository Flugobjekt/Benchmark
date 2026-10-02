KOTLINC = kotlinc

all: cold_start.jar

cold_start.jar: Main.kt
	$(KOTLINC) -include-runtime -d cold_start.jar Main.kt

run: cold_start.jar
	./run_cold_start.sh

clean:
	rm -f cold_start.jar

.PHONY: all run clean
