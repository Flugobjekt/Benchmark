const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const dir_path = "tmp_io_test";
    const cwd = std.Io.Dir.cwd();

    cwd.deleteTree(io, dir_path) catch {};
    try cwd.createDir(io, dir_path, .default_dir);
    var dir = try cwd.openDir(io, dir_path, .{});
    defer dir.close(io);

    const match_content = "First line\nBenchmark\nThird line\n";
    const nomatch_content = "First line\nSecond line\nThird line\n";

    var name_buf: [32]u8 = undefined;

    var i: usize = 0;
    while (i < 10_000) : (i += 1) {
        const file_name = try std.fmt.bufPrint(&name_buf, "file_{d}.txt", .{i});
        const content = if (i % 10 == 0) match_content else nomatch_content;
        try dir.writeFile(io, .{ .sub_path = file_name, .data = content });
    }

    var start: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &start);

    var matches: usize = 0;
    var read_buf: [128]u8 = undefined;
    i = 0;
    while (i < 10_000) : (i += 1) {
        const file_name = try std.fmt.bufPrint(&name_buf, "file_{d}.txt", .{i});
        const read_bytes = try dir.readFile(io, file_name, &read_buf);
        if (std.mem.indexOf(u8, read_bytes, "Benchmark") != null) {
            matches += 1;
        }
    }

    var end: std.posix.timespec = undefined;
    _ = std.posix.system.clock_gettime(std.posix.system.CLOCK.MONOTONIC, &end);

    const elapsed_ns = @as(f64, @floatFromInt((end.sec - start.sec) * 1_000_000_000 + (end.nsec - start.nsec)));
    const elapsed_ms = elapsed_ns / 1_000_000.0;
    const elapsed_s = elapsed_ns / 1_000_000_000.0;

    std.debug.print("  [IO-Bound] Files: 10000 | Matches: {d} | Time: {d:.4} ms ({d:.6} s)\n", .{
        matches, elapsed_ms, elapsed_s,
    });

    try cwd.deleteTree(io, dir_path);
}
