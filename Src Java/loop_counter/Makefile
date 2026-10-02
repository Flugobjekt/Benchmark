JAVAC = javac
JAVA = java

all: Main.class

Main.class: Main.java
	$(JAVAC) Main.java

run: Main.class
	$(JAVA) Main

clean:
	rm -f *.class

.PHONY: all run clean
