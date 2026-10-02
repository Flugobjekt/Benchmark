all: run

run:
	./run_all.sh

clean:
	cd "Src C" && make clean
	cd "Src cpp" && make clean
	cd "Src Rust" && make clean
	cd "Src Zig" && make clean
	cd "Src Go" && make clean
	cd "Src C#" && make clean
	cd "Src Java" && make clean
	cd "Src Js" && make clean
	cd "Src Ts" && make clean
	cd "Src Py" && make clean
	cd "Src Lua" && make clean
	cd "Src Swift" && make clean
	cd "Src HolyC" && make clean
	cd "Src Kotlin" && make clean
	cd "Src Dlang" && make clean

.PHONY: all run clean
