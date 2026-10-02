# Installation Guide: Toolchains & Package Managers

This guide provides instructions to install the compilers, runtimes, and tools for all **15 benchmarked languages** on Linux.

---

## 1. System Essentials (C, C++, Make, Curl, CMake)

```sh
# Fedora / RHEL / Bazzite
sudo dnf install -y gcc gcc-c++ make cmake curl tar xz luajit

# Ubuntu / Debian
sudo apt-get update && sudo apt-get install -y build-essential cmake curl tar xz-utils luajit

# Arch Linux
sudo pacman -S --needed base-devel cmake curl tar xz luajit
```

Ensure `~/.local/bin` exists and is in your `PATH`:

```sh
mkdir -p ~/.local/bin ~/.local/opt
export PATH="$HOME/.local/bin:$PATH"
```

---

## 2. Language Toolchain Installations

### Rust
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal
ln -sf ~/.cargo/bin/* ~/.local/bin/
```

### Zig
```sh
curl -L https://ziglang.org/download/0.16.0/zig-x86_64-linux-0.16.0.tar.xz | tar -xJ -C ~/.local/opt/
ln -sf ~/.local/opt/zig-x86_64-linux-0.16.0/zig ~/.local/bin/zig
```

### Go
```sh
curl -L https://go.dev/dl/go1.27.1.linux-amd64.tar.gz | tar -xz -C ~/.local/opt/
ln -sf ~/.local/opt/go/bin/go ~/.local/bin/go
ln -sf ~/.local/opt/go/bin/gofmt ~/.local/bin/gofmt
```

### JavaScript & TypeScript
```sh
curl -fsSL https://bun.sh/install | bash
ln -sf ~/.bun/bin/bun ~/.local/bin/bun
```

### Python
```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### C#
```sh
curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS
ln -sf ~/.dotnet/dotnet ~/.local/bin/dotnet
```

### Java
```sh
brew install openjdk
```

### Lua
```sh
# Fedora / Bazzite
sudo dnf install -y luajit

# Ubuntu / Debian
sudo apt-get install -y luajit
```

### Swift
```sh
brew install swift
ln -sf /home/linuxbrew/.linuxbrew/bin/swift* ~/.local/bin/
```

### HolyC
```sh
git clone --depth 1 https://github.com/Jamesbarford/holyc-lang.git /tmp/holyc-lang
cmake -S /tmp/holyc-lang/src -B /tmp/holyc-lang/build -DCMAKE_BUILD_TYPE=Release
make -C /tmp/holyc-lang/build -j$(nproc)

stage="$HOME/.local/opt/holyc-lang"
mkdir -p "$stage/bin" "$stage/include" "$stage/lib"
cp /tmp/holyc-lang/hcc "$stage/bin/hcc"
cp -r /tmp/holyc-lang/src/holyc-lib/* "$stage/include/"

(cd /tmp/holyc-lang/src/holyc-lib && \
  "$stage/bin/hcc" --target=x86_64-unknown-linux-gnu --install-dir="$stage" -fPIC -S -o /tmp/tos.s ./all.HC)
gcc -fPIC -c /tmp/tos.s -o /tmp/tos.o
ar rcs "$stage/lib/libtos.a" /tmp/tos.o
gcc -fPIC -shared -Wl,-Bsymbolic -Wl,-soname,libtos.so.0.0.1 /tmp/tos.o -o "$stage/lib/libtos.so.0.0.1" -lpthread -lc -lm
rm -f /tmp/tos.s /tmp/tos.o

cat << 'EOF' > ~/.local/bin/holyc
#!/usr/bin/env bash
exec /home/flieger/.local/opt/holyc-lang/bin/hcc --install-dir /home/flieger/.local/opt/holyc-lang "$@"
EOF
chmod +x ~/.local/bin/holyc
```

### Kotlin
```sh
brew install kotlin
ln -sf /home/linuxbrew/.linuxbrew/bin/kotlinc* ~/.local/bin/
ln -sf /home/linuxbrew/.linuxbrew/Cellar/kotlin/2.4.20/bin/kotlin ~/.local/bin/kotlin
```

### Dlang
```sh
brew install dmd
ln -sf /home/linuxbrew/.linuxbrew/bin/dmd ~/.local/bin/dmd
```

---

## 3. Verify All 15 Toolchains

```sh
gcc --version | head -n 1 && \
g++ --version | head -n 1 && \
rustc --version && \
zig version && \
go version && \
dotnet --version && \
javac --version && \
bun --version && \
uv --version && \
luajit -v && \
swift --version && \
holyc --version && \
kotlinc -version && \
dmd --version
```
