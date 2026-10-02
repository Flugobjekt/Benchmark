local ffi = require("ffi")

ffi.cdef[[
    typedef long time_t;
    struct timespec {
        time_t tv_sec;
        long   tv_nsec;
    };
    int clock_gettime(int clk_id, struct timespec *tp);
    int mkdir(const char *pathname, unsigned int mode);
    int open(const char *pathname, int flags, ...);
    int close(int fd);
    long read(int fd, void *buf, size_t count);
    char *strstr(const char *haystack, const char *needle);
]]

local dir = "./tmp_io_test"
os.execute("rm -rf " .. dir)
ffi.C.mkdir(dir, 511)

local line_match = "Line 1: Sample data\nLine 2: Benchmark\nLine 3: End of file\n"
local line_normal = "Line 1: Sample data\nLine 2: Nothing special\nLine 3: End of file\n"

for i = 0, 9999 do
    local f = io.open(dir .. "/file_" .. i .. ".txt", "w")
    if i % 10 == 0 then
        f:write(line_match)
    else
        f:write(line_normal)
    end
    f:close()
end

local ts_start = ffi.new("struct timespec")
local ts_end = ffi.new("struct timespec")

ffi.C.clock_gettime(1, ts_start)

local matches = 0
local buf = ffi.new("char[256]")
local needle = "Benchmark"

for i = 0, 9999 do
    local path = dir .. "/file_" .. i .. ".txt"
    local fd = ffi.C.open(path, 0)
    if fd >= 0 then
        local n = ffi.C.read(fd, buf, 255)
        if n > 0 then
            buf[n] = 0
            if ffi.C.strstr(buf, needle) ~= nil then
                matches = matches + 1
            end
        end
        ffi.C.close(fd)
    end
end

ffi.C.clock_gettime(1, ts_end)

os.execute("rm -rf " .. dir)

local elapsed_ms = (tonumber(ts_end.tv_sec) - tonumber(ts_start.tv_sec)) * 1000.0 + (tonumber(ts_end.tv_nsec) - tonumber(ts_start.tv_nsec)) / 1000000.0
local elapsed_s = elapsed_ms / 1000.0

print(string.format("  [IO-Bound] Files: 10000 | Matches: %d | Time: %.4f ms (%.6f s)", matches, elapsed_ms, elapsed_s))
assert(matches == 1000)
