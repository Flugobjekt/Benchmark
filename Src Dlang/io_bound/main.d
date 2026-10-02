import core.atomic : atomicOp;
import core.time : MonoTime, Duration;
import std.file : exists, mkdir, read, rmdirRecurse, write;
import std.format : format;
import std.parallelism : parallel;
import std.range : iota;
import std.stdio : writefln;
import std.string : indexOf;

void main() {
    string dir = "./tmp_io_test";
    if (exists(dir)) {
        rmdirRecurse(dir);
    }
    mkdir(dir);

    foreach (i; parallel(iota(10000))) {
        string p = format("%s/file_%d.txt", dir, i);
        if (i % 10 == 0) {
            write(p, "Line 1: Sample data\nLine 2: Benchmark\nLine 3: End of file\n");
        } else {
            write(p, "Line 1: Sample data\nLine 2: Nothing special\nLine 3: End of file\n");
        }
    }

    MonoTime start = MonoTime.currTime;

    shared int matches = 0;
    foreach (i; parallel(iota(10000))) {
        string p = format("%s/file_%d.txt", dir, i);
        auto data = cast(string) read(p);
        if (data.indexOf("Benchmark") != -1) {
            atomicOp!"+="(matches, 1);
        }
    }

    MonoTime end = MonoTime.currTime;

    if (exists(dir)) {
        rmdirRecurse(dir);
    }

    Duration elapsed = end - start;
    double elapsedMs = cast(double) elapsed.total!"nsecs" / 1_000_000.0;
    double elapsedS = cast(double) elapsed.total!"nsecs" / 1_000_000_000.0;

    writefln("  [IO-Bound] Files: 10000 | Matches: %d | Time: %.4f ms (%.6f s)",
             matches, elapsedMs, elapsedS);

    assert(matches == 1000);
}
