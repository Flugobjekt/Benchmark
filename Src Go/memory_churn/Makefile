TARGET = memory_churn

all: $(TARGET)

build: $(TARGET)

$(TARGET): main.go
	go build -ldflags="-s -w" -o $(TARGET) main.go

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all run clean
