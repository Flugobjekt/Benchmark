const std = @import("std");

fn run_sieve(allocator: std.mem.Allocator, limit: usize, expected: usize) !void {
    const num_odds = limit / 2;
    const is_prime = try allocator.alloc(u8, num_odds);
    defer allocator.free(is_prime);

    @memset(is_prime, 1);
    if (num_odds > 0) {
        is_prime[0] = 0;
    }

    const ptr = is_prime.ptr;

    var start: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &start);

    var i: usize = 1;
    while ((2 * i + 1) * (2 * i + 1) < limit) : (i += 1) {
        if (ptr[i] != 0) {
            const p = 2 * i + 1;
            var j = 2 * i * (i + 1);
            const p4 = 4 * p;

            while (j + p4 <= num_odds) : (j += p4) {
                ptr[j] = 0;
                ptr[j + p] = 0;
                ptr[j + 2 * p] = 0;
                ptr[j + 3 * p] = 0;
            }

            while (j < num_odds) : (j += p) {
                ptr[j] = 0;
            }
        }
    }

    var end: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &end);

    asm volatile (""
        :
        : [p] "r" (ptr),
    );

    var prime_count: usize = 1;
    for (is_prime[1..]) |v| {
        prime_count += v;
    }

    const elapsed_ns = @as(f64, @floatFromInt((end.sec - start.sec) * 1_000_000_000 + (end.nsec - start.nsec)));
    const elapsed_ms = elapsed_ns / 1_000_000.0;
    const elapsed_s = elapsed_ns / 1_000_000_000.0;

    std.debug.print("  [Sieve]   Limit: {d: >11} | Primes: {d: >9} | Time: {d: >10.4} ms ({d: >8.6} s)\n", .{
        limit, prime_count, elapsed_ms, elapsed_s,
    });

    std.debug.assert(prime_count == expected);
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    std.debug.print("-- Prime Sieve --\n", .{});
    try run_sieve(allocator, 1_000_000, 78_498);
    try run_sieve(allocator, 10_000_000, 664_579);
    try run_sieve(allocator, 100_000_000, 5_761_455);
    try run_sieve(allocator, 1_000_000_000, 50_847_534);
}
