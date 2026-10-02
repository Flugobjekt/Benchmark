import time


def run_sieve(limit: int, expected: int) -> None:
    num_odds = limit // 2
    sieve = bytearray(b"\x01") * num_odds
    if num_odds > 0:
        sieve[0] = 0

    zero_buf = b"\x00" * (num_odds // 3 + 1)

    start = time.perf_counter()

    i = 1
    while (2 * i + 1) * (2 * i + 1) < limit:
        if sieve[i]:
            p = 2 * i + 1
            st = 2 * i * (i + 1)
            cnt = (num_odds - 1 - st) // p + 1
            sieve[st::p] = zero_buf[:cnt]
        i += 1

    end = time.perf_counter()
    elapsed_s = end - start
    elapsed_ms = elapsed_s * 1000.0

    prime_count = 1 + sum(sieve)

    print(
        f"  [Sieve]   Limit: {limit:>11} | Primes: {prime_count:>9} | Time: {elapsed_ms:>10.4f} ms ({elapsed_s:>8.6f} s)"
    )

    if prime_count != expected:
        raise ValueError(f"ERROR: Expected {expected}, got {prime_count}")


def main() -> None:
    print("-- Prime Sieve --")
    run_sieve(1_000_000, 78_498)
    run_sieve(10_000_000, 664_579)
    run_sieve(100_000_000, 5_761_455)
    run_sieve(1_000_000_000, 50_847_534)


if __name__ == "__main__":
    main()
