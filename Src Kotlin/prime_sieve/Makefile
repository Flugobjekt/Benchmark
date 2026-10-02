KOTLINC = kotlinc
JAVA = java

all: Main.jar

Main.jar: Main.kt
	$(KOTLINC) -include-runtime -d Main.jar Main.kt

run: Main.jar
	$(JAVA) -jar Main.jar

clean:
	rm -f Main.jar

.PHONY: all run clean
