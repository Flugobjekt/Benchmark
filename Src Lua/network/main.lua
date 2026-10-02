local ffi = require("ffi")

ffi.cdef[[
    typedef int pid_t;
    typedef unsigned short in_port_t;
    typedef unsigned int in_addr_t;
    typedef unsigned short sa_family_t;
    typedef unsigned int socklen_t;
    typedef long time_t;

    struct in_addr {
        in_addr_t s_addr;
    };
    struct sockaddr_in {
        sa_family_t sin_family;
        in_port_t sin_port;
        struct in_addr sin_addr;
        char sin_zero[8];
    };
    struct sockaddr {
        sa_family_t sa_family;
        char sa_data[14];
    };
    struct timespec {
        time_t tv_sec;
        long   tv_nsec;
    };

    int socket(int domain, int type, int protocol);
    int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
    int listen(int sockfd, int backlog);
    int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
    int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
    int getsockname(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
    long send(int sockfd, const void *buf, size_t len, int flags);
    long recv(int sockfd, void *buf, size_t len, int flags);
    int close(int fd);
    pid_t fork(void);
    pid_t waitpid(pid_t pid, int *status, int options);
    void _exit(int status);
    int clock_gettime(int clk_id, struct timespec *tp);
    uint32_t htonl(uint32_t hostlong);
]]

local total_packets = 100000
local packet_size = 64
local total_bytes = total_packets * packet_size

local sfd = ffi.C.socket(2, 1, 0)
local s_addr = ffi.new("struct sockaddr_in")
s_addr.sin_family = 2
s_addr.sin_addr.s_addr = ffi.C.htonl(0x7F000001)
s_addr.sin_port = 0

ffi.C.bind(sfd, ffi.cast("struct sockaddr*", s_addr), ffi.sizeof("struct sockaddr_in"))
ffi.C.listen(sfd, 1)

local slen = ffi.new("socklen_t[1]", ffi.sizeof("struct sockaddr_in"))
ffi.C.getsockname(sfd, ffi.cast("struct sockaddr*", s_addr), slen)

local pid = ffi.C.fork()
if pid == 0 then
    local cfd = ffi.C.accept(sfd, nil, nil)
    ffi.C.close(sfd)
    local buf = ffi.new("char[65536]")
    local total = 0
    while total < total_bytes do
        local n = ffi.C.recv(cfd, buf, 65536, 0)
        if n <= 0 then
            break
        end
        total = total + tonumber(n)
    end
    local ack = ffi.new("char[1]", 1)
    ffi.C.send(cfd, ack, 1, 0)
    ffi.C.close(cfd)
    ffi.C._exit(0)
else
    ffi.C.close(sfd)
    local cfd = ffi.C.socket(2, 1, 0)
    ffi.C.connect(cfd, ffi.cast("struct sockaddr*", s_addr), ffi.sizeof("struct sockaddr_in"))
    local packet = ffi.new("char[?]", packet_size)
    local ts_start = ffi.new("struct timespec")
    local ts_end = ffi.new("struct timespec")

    ffi.C.clock_gettime(1, ts_start)
    for i = 1, total_packets do
        local sent = 0
        while sent < packet_size do
            local n = ffi.C.send(cfd, packet + sent, packet_size - sent, 0)
            if n <= 0 then
                break
            end
            sent = sent + tonumber(n)
        end
    end
    local ack = ffi.new("char[1]")
    ffi.C.recv(cfd, ack, 1, 0)
    ffi.C.clock_gettime(1, ts_end)
    ffi.C.close(cfd)
    ffi.C.waitpid(pid, nil, 0)

    local elapsed_ms = (tonumber(ts_end.tv_sec) - tonumber(ts_start.tv_sec)) * 1000.0 + (tonumber(ts_end.tv_nsec) - tonumber(ts_start.tv_nsec)) / 1000000.0
    local elapsed_s = elapsed_ms / 1000.0
    print(string.format("  [Network] Packets: %d | Size: %d B | Time: %.4f ms (%.6f s)", total_packets, packet_size, elapsed_ms, elapsed_s))
end
