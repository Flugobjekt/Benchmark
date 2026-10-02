import time


def run_counter(limit: int) -> None:
    start = time.perf_counter()

    count = 0
    for _ in range(limit):
        count += 1

    end = time.perf_counter()
    elapsed_s = end - start
    elapsed_ms = elapsed_s * 1000.0

    print(
        f"  [Counter] Limit: {limit:>11} | Count:  {count:>9} | Time: {elapsed_ms:>10.4f} ms ({elapsed_s:>8.6f} s)"
    )

    if count != limit:
        raise ValueError(f"ERROR: Expected {limit}, got {count}")


def main() -> None:
    print("-- Loop Counter --")
    run_counter(1_000_000)
    run_counter(10_000_000)
    run_counter(100_000_000)
    run_counter(1_000_000_000)


if __name__ == "__main__":
    main()
