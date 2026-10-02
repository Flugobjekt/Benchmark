import core.thread.osthread : Thread;
import core.time : MonoTime, Duration, dur;
import std.stdio : writefln;

void main() {
    MonoTime start = MonoTime.currTime;

    Thread[500] threads;
    foreach (ref t; threads) {
        t = new Thread({
            Thread.sleep(dur!"msecs"(200));
        });
        t.start();
    }

    foreach (t; threads) {
        t.join();
    }

    MonoTime end = MonoTime.currTime;

    Duration elapsed = end - start;
    double elapsedMs = cast(double) elapsed.total!"nsecs" / 1_000_000.0;
    double elapsedS = cast(double) elapsed.total!"nsecs" / 1_000_000_000.0;

    writefln("  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: %.4f ms (%.6f s)",
             elapsedMs, elapsedS);
}
