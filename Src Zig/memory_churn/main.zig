const std = @import("std");

const Node = struct {
    id: i32,
    value: f64,
    text: [32]u8,
};

pub fn main() !void {
    const allocator = std.heap.c_allocator;

    var start: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &start);

    const nodes = try allocator.alloc(*Node, 5_000_000);
    defer allocator.free(nodes);

    var i: usize = 0;
    while (i < 5_000_000) : (i += 1) {
        const n = try allocator.create(Node);
        n.id = @intCast(i);
        n.value = @floatFromInt(i);
        _ = std.fmt.bufPrint(&n.text, "node_{d}", .{i}) catch unreachable;
        nodes[i] = n;
    }

    i = 3_000_000;
    while (i < 5_000_000) : (i += 1) {
        allocator.destroy(nodes[i]);
    }

    i = 3_000_000;
    while (i < 5_000_000) : (i += 1) {
        const n = try allocator.create(Node);
        n.id = @intCast(i);
        n.value = @floatFromInt(i);
        _ = std.fmt.bufPrint(&n.text, "new_{d}", .{i}) catch unreachable;
        nodes[i] = n;
    }

    var end: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &end);

    const elapsed_ns = @as(f64, @floatFromInt((end.sec - start.sec) * 1_000_000_000 + (end.nsec - start.nsec)));
    const elapsed_ms = elapsed_ns / 1_000_000.0;
    const elapsed_s = elapsed_ns / 1_000_000_000.0;

    std.debug.print("  [Memory] Final Nodes: 5000000 | Time: {d:.4} ms ({d:.6} s)\n", .{
        elapsed_ms, elapsed_s,
    });

    for (nodes) |n| {
        allocator.destroy(n);
    }
}
