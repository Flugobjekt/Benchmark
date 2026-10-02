const std = @import("std");

fn sleep_ms(ms: u64) void {
    const req = std.posix.timespec{
        .sec = @intCast(ms / 1000),
        .nsec = @intCast((ms % 1000) * 1_000_000),
    };
    _ = std.posix.system.nanosleep(&req, null);
}

fn worker() void {
    sleep_ms(200);
}

pub fn main() !void {
    var start: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &start);

    var threads: [500]std.Thread = undefined;
    for (&threads) |*t| {
        t.* = try std.Thread.spawn(.{}, worker, .{});
    }
    for (threads) |t| {
        t.join();
    }

    var end: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &end);

    const elapsed_ns = @as(f64, @floatFromInt((end.sec - start.sec) * 1_000_000_000 + (end.nsec - start.nsec)));
    const elapsed_ms = elapsed_ns / 1_000_000.0;
    const elapsed_s = elapsed_ns / 1_000_000_000.0;

    std.debug.print("  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: {d:.4} ms ({d:.6} s)\n", .{
        elapsed_ms, elapsed_s,
    });
}
