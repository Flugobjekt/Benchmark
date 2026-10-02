local ffi = require("ffi")

ffi.cdef[[
    typedef long time_t;
    struct timespec {
        time_t tv_sec;
        long   tv_nsec;
    };
    int clock_gettime(int clk_id, struct timespec *tp);
    typedef struct {
        int id;
        double value;
        char text[32];
    } Node;
    void *malloc(size_t size);
    void free(void *ptr);
    int snprintf(char *str, size_t size, const char *format, ...);
]]

local ts_start = ffi.new("struct timespec")
local ts_end = ffi.new("struct timespec")

ffi.C.clock_gettime(1, ts_start)

local nodes = ffi.cast("Node**", ffi.C.malloc(5000000 * ffi.sizeof("Node*")))
for i = 0, 4999999 do
    local n = ffi.cast("Node*", ffi.C.malloc(ffi.sizeof("Node")))
    n.id = i
    n.value = i * 1.5
    ffi.C.snprintf(n.text, 32, "node_%d", i)
    nodes[i] = n
end

for i = 3000000, 4999999 do
    ffi.C.free(nodes[i])
end

for i = 3000000, 4999999 do
    local n = ffi.cast("Node*", ffi.C.malloc(ffi.sizeof("Node")))
    n.id = i
    n.value = i * 1.5
    ffi.C.snprintf(n.text, 32, "new_%d", i)
    nodes[i] = n
end

ffi.C.clock_gettime(1, ts_end)

local elapsed_ms = (tonumber(ts_end.tv_sec) - tonumber(ts_start.tv_sec)) * 1000.0 + (tonumber(ts_end.tv_nsec) - tonumber(ts_start.tv_nsec)) / 1000000.0
local elapsed_s = elapsed_ms / 1000.0

print(string.format("  [Memory] Final Nodes: 5000000 | Time: %.4f ms (%.6f s)", elapsed_ms, elapsed_s))

for i = 0, 4999999 do
    ffi.C.free(nodes[i])
end
ffi.C.free(nodes)
