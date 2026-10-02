DOTNET = dotnet

all: run

build:
	$(DOTNET) build -c Release

run:
	$(DOTNET) run -c Release

clean:
	$(DOTNET) clean
	rm -rf bin obj

.PHONY: all build run clean
