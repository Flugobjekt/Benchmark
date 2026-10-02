JAVAC = javac
JAVA = java

all: Main.class

Main.class: Main.java
	$(JAVAC) Main.java

run: Main.class
	$(JAVA) Main

clean:
	rm -rf *.class tmp_io_test

.PHONY: all run clean
