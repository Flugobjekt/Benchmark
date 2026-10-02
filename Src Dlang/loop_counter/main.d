import core.time : MonoTime, Duration;
import std.stdio : writefln;

void runCounter(ulong limit) {
    MonoTime start = MonoTime.currTime;

    ulong count = 0;
    for (ulong i = 1; i <= limit; ++i) {
        count += 1;
        asm { }
    }

    MonoTime end = MonoTime.currTime;

    Duration elapsed = end - start;
    double elapsedMs = cast(double) elapsed.total!"nsecs" / 1_000_000.0;
    double elapsedS = cast(double) elapsed.total!"nsecs" / 1_000_000_000.0;

    writefln("  [Counter] Limit: %11d | Count:  %9d | Time: %10.4f ms (%8.6f s)",
             limit, count, elapsedMs, elapsedS);

    assert(count == limit);
}

void main() {
    runCounter(1_000_000);
    runCounter(10_000_000);
    runCounter(100_000_000);
    runCounter(1_000_000_000);
}
