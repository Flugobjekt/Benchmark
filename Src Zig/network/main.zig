const std = @import("std");

const NUM_PACKETS: usize = 100_000;
const PACKET_SIZE: usize = 64;
const TOTAL_BYTES: usize = NUM_PACKETS * PACKET_SIZE;
const CHUNK_SIZE: usize = 65_536;

fn validate_packet(pkt: []const u8, expected: u32) void {
    const seq = @as(u32, pkt[0]) |
        (@as(u32, pkt[1]) << 8) |
        (@as(u32, pkt[2]) << 16) |
        (@as(u32, pkt[3]) << 24);
    if (seq != expected) {
        std.debug.print("Packet sequence mismatch: expected {d}, got {d}\n", .{ expected, seq });
        std.process.exit(1);
    }
    const expected_byte: u8 = @truncate(expected);
    for (pkt[4..PACKET_SIZE]) |b| {
        if (b != expected_byte) {
            std.debug.print("Packet payload mismatch\n", .{});
            std.process.exit(1);
        }
    }
}

fn server_worker(port_val: *std.atomic.Value(u16), end_ts: *std.posix.timespec) void {
    const sys = std.posix.system;
    const sock_rc = sys.socket(std.posix.AF.INET, std.posix.SOCK.STREAM, 0);
    const listen_fd: i32 = @intCast(sock_rc);
    defer _ = sys.close(listen_fd);

    var opt: i32 = 1;
    _ = sys.setsockopt(listen_fd, std.posix.SOL.SOCKET, std.posix.SO.REUSEADDR, @ptrCast(&opt), @sizeOf(i32));

    var serv_addr: std.posix.sockaddr.in = .{
        .family = std.posix.AF.INET,
        .port = 0,
        .addr = std.mem.nativeToBig(u32, 0x7F000001),
        .zero = [_]u8{0} ** 8,
    };

    _ = sys.bind(listen_fd, @ptrCast(&serv_addr), @sizeOf(std.posix.sockaddr.in));
    _ = sys.listen(listen_fd, 1);

    var sa_len: u32 = @sizeOf(std.posix.sockaddr.in);
    _ = sys.getsockname(listen_fd, @ptrCast(&serv_addr), &sa_len);
    const port = std.mem.bigToNative(u16, serv_addr.port);
    port_val.store(port, .release);

    const client_rc = sys.accept(listen_fd, null, null);
    const client_fd: i32 = @intCast(client_rc);
    defer _ = sys.close(client_fd);

    _ = sys.setsockopt(client_fd, std.posix.IPPROTO.TCP, 1, @ptrCast(&opt), @sizeOf(i32));

    var recv_buf: [CHUNK_SIZE]u8 = undefined;
    var packet_buf: [PACKET_SIZE]u8 = undefined;
    var packet_rem: usize = 0;
    var packets_received: u32 = 0;
    var total_received: usize = 0;

    while (total_received < TOTAL_BYTES) {
        const n_rc = sys.read(client_fd, &recv_buf, CHUNK_SIZE);
        const err = std.posix.errno(n_rc);
        if (err != .SUCCESS) {
            break;
        }
        if (n_rc == 0) {
            break;
        }
        const n: usize = n_rc;

        var offset: usize = 0;
        const bytes_left = n;

        while (offset < bytes_left) {
            if (packet_rem > 0) {
                const needed = PACKET_SIZE - packet_rem;
                const avail = bytes_left - offset;
                const to_copy = @min(avail, needed);
                @memcpy(packet_buf[packet_rem .. packet_rem + to_copy], recv_buf[offset .. offset + to_copy]);
                packet_rem += to_copy;
                offset += to_copy;

                if (packet_rem == PACKET_SIZE) {
                    validate_packet(&packet_buf, packets_received);
                    packets_received += 1;
                    packet_rem = 0;
                }
            } else if (bytes_left - offset >= PACKET_SIZE) {
                validate_packet(recv_buf[offset .. offset + PACKET_SIZE], packets_received);
                packets_received += 1;
                offset += PACKET_SIZE;
            } else {
                const to_copy = bytes_left - offset;
                @memcpy(packet_buf[0..to_copy], recv_buf[offset .. offset + to_copy]);
                packet_rem = to_copy;
                offset += to_copy;
            }
        }

        total_received += n;
        if (total_received == TOTAL_BYTES) {
            _ = sys.clock_gettime(sys.CLOCK.MONOTONIC, end_ts);
            break;
        }
    }
}

pub fn main() !void {
    const sys = std.posix.system;
    const allocator = std.heap.page_allocator;

    const send_buf = try allocator.alloc(u8, TOTAL_BYTES);
    defer allocator.free(send_buf);

    var i: usize = 0;
    while (i < NUM_PACKETS) : (i += 1) {
        const offset = i * PACKET_SIZE;
        const seq = @as(u32, @intCast(i));
        send_buf[offset + 0] = @truncate(seq);
        send_buf[offset + 1] = @truncate(seq >> 8);
        send_buf[offset + 2] = @truncate(seq >> 16);
        send_buf[offset + 3] = @truncate(seq >> 24);
        @memset(send_buf[offset + 4 .. offset + PACKET_SIZE], @truncate(seq));
    }

    var port_val = std.atomic.Value(u16).init(0);
    var end_ts: std.posix.timespec = undefined;

    const server_thr = try std.Thread.spawn(.{}, server_worker, .{ &port_val, &end_ts });

    while (port_val.load(.acquire) == 0) {
        std.Thread.yield() catch {};
    }
    const port = port_val.load(.acquire);

    const sock_rc = sys.socket(std.posix.AF.INET, std.posix.SOCK.STREAM, 0);
    const client_fd: i32 = @intCast(sock_rc);
    defer _ = sys.close(client_fd);

    var opt: i32 = 1;
    _ = sys.setsockopt(client_fd, std.posix.IPPROTO.TCP, 1, @ptrCast(&opt), @sizeOf(i32));

    const serv_addr: std.posix.sockaddr.in = .{
        .family = std.posix.AF.INET,
        .port = std.mem.nativeToBig(u16, port),
        .addr = std.mem.nativeToBig(u32, 0x7F000001),
        .zero = [_]u8{0} ** 8,
    };

    _ = sys.connect(client_fd, @ptrCast(&serv_addr), @sizeOf(std.posix.sockaddr.in));

    var start_ts: std.posix.timespec = undefined;
    _ = sys.clock_gettime(sys.CLOCK.MONOTONIC, &start_ts);

    var total_sent: usize = 0;
    while (total_sent < TOTAL_BYTES) {
        const chunk = @min(TOTAL_BYTES - total_sent, CHUNK_SIZE);
        const n_rc = sys.write(client_fd, send_buf.ptr + total_sent, chunk);
        const err = std.posix.errno(n_rc);
        if (err != .SUCCESS) {
            break;
        }
        if (n_rc == 0) {
            break;
        }
        total_sent += n_rc;
    }

    _ = sys.shutdown(client_fd, std.posix.SHUT.WR);
    server_thr.join();

    const elapsed_ns = @as(f64, @floatFromInt((end_ts.sec - start_ts.sec) * 1_000_000_000 + (end_ts.nsec - start_ts.nsec)));
    const elapsed_ms = elapsed_ns / 1_000_000.0;
    const elapsed_s = elapsed_ns / 1_000_000_000.0;

    std.debug.print("  [Network] Packets: {d} | Size: {d} B | Time: {d:.4} ms ({d:.6} s)\n", .{
        NUM_PACKETS, PACKET_SIZE, elapsed_ms, elapsed_s,
    });
}
