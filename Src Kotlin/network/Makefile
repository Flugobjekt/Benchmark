KOTLINC = kotlinc
JAVA = java
TARGET = Main.jar

all: build

build: $(TARGET)

$(TARGET): Main.kt
	$(KOTLINC) -include-runtime -d $(TARGET) Main.kt

run: $(TARGET)
	$(JAVA) -jar $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all build run clean
