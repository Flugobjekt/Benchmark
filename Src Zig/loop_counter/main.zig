const std = @import("std");

fn run_counter(limit: u64) void {
    var start: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &start);

    var count: u64 = 0;
    var i: u64 = 1;
    while (i <= limit) : (i += 1) {
        count += 1;
        asm volatile (""
            :
            : [c] "r" (&count),
        );
    }

    var end: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &end);

    const elapsed_ns = @as(f64, @floatFromInt((end.sec - start.sec) * 1_000_000_000 + (end.nsec - start.nsec)));
    const elapsed_ms = elapsed_ns / 1_000_000.0;
    const elapsed_s = elapsed_ns / 1_000_000_000.0;

    std.debug.print("  [Counter] Limit: {d: >11} | Count:  {d: >9} | Time: {d: >10.4} ms ({d: >8.6} s)\n", .{
        limit, count, elapsed_ms, elapsed_s,
    });

    std.debug.assert(count == limit);
}

pub fn main() !void {
    std.debug.print("-- Loop Counter --\n", .{});
    run_counter(1_000_000);
    run_counter(10_000_000);
    run_counter(100_000_000);
    run_counter(1_000_000_000);
}
