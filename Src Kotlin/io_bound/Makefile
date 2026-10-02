KOTLINC = kotlinc
JAVA = java

all: Main.jar

Main.jar: Main.kt
	$(KOTLINC) -include-runtime -d Main.jar Main.kt

run: Main.jar
	$(JAVA) -jar Main.jar

clean:
	rm -rf Main.jar ./tmp_io_test

.PHONY: all run clean
