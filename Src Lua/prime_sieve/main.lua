local ffi = require("ffi")

ffi.cdef[[
    typedef long time_t;
    struct timespec {
        time_t tv_sec;
        long   tv_nsec;
    };
    int clock_gettime(int clk_id, struct timespec *tp);
    void *memset(void *s, int c, size_t n);
]]

local function run_sieve(limit, expected)
    local num_odds = math.floor(limit / 2)
    local is_prime = ffi.new("uint8_t[?]", num_odds)
    ffi.C.memset(is_prime, 1, num_odds)
    is_prime[0] = 0

    local ts_start = ffi.new("struct timespec")
    local ts_end = ffi.new("struct timespec")

    ffi.C.clock_gettime(1, ts_start)

    local i = 1
    while (2 * i + 1) * (2 * i + 1) < limit do
        if is_prime[i] == 1 then
            local p = 2 * i + 1
            local j = 2 * i * (i + 1)
            local p4 = 4 * p
            while j + p4 <= num_odds do
                is_prime[j] = 0
                is_prime[j + p] = 0
                is_prime[j + 2 * p] = 0
                is_prime[j + 3 * p] = 0
                j = j + p4
            end
            while j < num_odds do
                is_prime[j] = 0
                j = j + p
            end
        end
        i = i + 1
    end

    ffi.C.clock_gettime(1, ts_end)

    local count = 1
    for k = 1, num_odds - 1 do
        count = count + is_prime[k]
    end

    local elapsed_ms = (tonumber(ts_end.tv_sec) - tonumber(ts_start.tv_sec)) * 1000.0 + (tonumber(ts_end.tv_nsec) - tonumber(ts_start.tv_nsec)) / 1000000.0
    local elapsed_s = elapsed_ms / 1000.0

    print(string.format("  [Sieve]   Limit: %11d | Primes: %9d | Time: %10.4f ms (%8.6f s)", limit, count, elapsed_ms, elapsed_s))
    assert(count == expected)
end

run_sieve(1000000, 78498)
run_sieve(10000000, 664579)
run_sieve(100000000, 5761455)
run_sieve(1000000000, 50847534)
