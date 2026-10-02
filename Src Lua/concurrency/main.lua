local ffi = require("ffi")

ffi.cdef[[
    typedef long time_t;
    struct timespec {
        time_t tv_sec;
        long   tv_nsec;
    };
    int clock_gettime(int clk_id, struct timespec *tp);
    int poll(void *fds, unsigned long nfds, int timeout);
]]

local function get_time_s()
    local ts = ffi.new("struct timespec")
    ffi.C.clock_gettime(1, ts)
    return tonumber(ts.tv_sec) + tonumber(ts.tv_nsec) * 1e-9
end

local ts_start = ffi.new("struct timespec")
local ts_end = ffi.new("struct timespec")

ffi.C.clock_gettime(1, ts_start)

local waiting = {}
for i = 1, 500 do
    local co = coroutine.create(function()
        local wake_up = get_time_s() + 0.2
        coroutine.yield(wake_up)
    end)
    local _, wake_up = coroutine.resume(co)
    waiting[i] = {co = co, wake = wake_up}
end

while true do
    local now = get_time_s()
    local pending = 0
    local min_remaining = 1e9
    for i = 1, 500 do
        local item = waiting[i]
        if item.co then
            if now >= item.wake then
                coroutine.resume(item.co)
                item.co = nil
            else
                pending = pending + 1
                local rem = item.wake - now
                if rem < min_remaining then
                    min_remaining = rem
                end
            end
        end
    end
    if pending == 0 then
        break
    end
    if min_remaining > 0 then
        ffi.C.poll(nil, 0, math.ceil(min_remaining * 1000))
    end
end

ffi.C.clock_gettime(1, ts_end)

local elapsed_ms = (tonumber(ts_end.tv_sec) - tonumber(ts_start.tv_sec)) * 1000.0 + (tonumber(ts_end.tv_nsec) - tonumber(ts_start.tv_nsec)) / 1000000.0
local elapsed_s = elapsed_ms / 1000.0

print(string.format("  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: %.4f ms (%.6f s)", elapsed_ms, elapsed_s))
