local ffi = require("ffi")

ffi.cdef[[
    typedef long time_t;
    struct timespec {
        time_t tv_sec;
        long   tv_nsec;
    };
    int clock_gettime(int clk_id, struct timespec *tp);
]]

local sink = ffi.new("uint64_t[1]")
local ts_start = ffi.new("struct timespec")
local ts_end = ffi.new("struct timespec")

local function run_counter(limit)
    ffi.C.clock_gettime(1, ts_start)
    local count = 0
    for i = 1, limit do
        count = count + 1
    end
    sink[0] = count
    ffi.C.clock_gettime(1, ts_end)

    local elapsed_ms = (tonumber(ts_end.tv_sec) - tonumber(ts_start.tv_sec)) * 1000.0 + (tonumber(ts_end.tv_nsec) - tonumber(ts_start.tv_nsec)) / 1000000.0
    local elapsed_s = elapsed_ms / 1000.0

    print(string.format("  [Counter] Limit: %11d | Count:  %9d | Time: %10.4f ms (%8.6f s)", limit, count, elapsed_ms, elapsed_s))
    assert(count == limit)
end

run_counter(1000000)
run_counter(10000000)
run_counter(100000000)
run_counter(1000000000)
