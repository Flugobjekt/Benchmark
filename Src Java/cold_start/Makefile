JAVAC = javac
JAVA = java

all: Main.class

Main.class: Main.java
	$(JAVAC) Main.java

run: Main.class
	./run_cold_start.sh

clean:
	rm -f *.class

.PHONY: all run clean
