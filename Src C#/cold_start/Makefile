DOTNET = dotnet

all: run

build:
	$(DOTNET) publish -c Release -r linux-x64 /p:PublishAot=true /p:StripSymbols=true -o bin cold_start.csproj

run: build
	./run_cold_start.sh

clean:
	$(DOTNET) clean
	rm -rf bin obj

.PHONY: all build run clean
