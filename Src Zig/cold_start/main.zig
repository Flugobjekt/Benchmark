const std = @import("std");

const Config = struct {
    name: []const u8,
    version: i32,
};

pub fn main(init: std.process.Init) !void {
    const json_str = "{\"name\":\"Speedtest\",\"version\":1}";
    const parsed = try std.json.parseFromSlice(Config, init.gpa, json_str, .{});
    defer parsed.deinit();
    try std.Io.File.stdout().writeStreamingAll(init.io, parsed.value.name);
    try std.Io.File.stdout().writeStreamingAll(init.io, "\n");
}
