import os
import shutil
import time
from concurrent.futures import ThreadPoolExecutor

DIR = "./tmp_io_test"


def check_chunk(indices: range) -> int:
    cnt = 0
    for i in indices:
        with open(f"{DIR}/file_{i}.txt", "r") as f:
            if "Benchmark" in f.read():
                cnt += 1
    return cnt


def main() -> None:
    shutil.rmtree(DIR, ignore_errors=True)
    os.makedirs(DIR, exist_ok=True)

    for i in range(10000):
        content = (
            "line1\nBenchmark\nline3\n"
            if i % 10 == 0
            else "line1\nline2\nline3\n"
        )
        with open(f"{DIR}/file_{i}.txt", "w") as f:
            f.write(content)

    start = time.perf_counter()

    workers = 16
    chunks = [range(i, 10000, workers) for i in range(workers)]
    with ThreadPoolExecutor(max_workers=workers) as executor:
        matches = sum(executor.map(check_chunk, chunks))

    end = time.perf_counter()

    shutil.rmtree(DIR, ignore_errors=True)

    if matches != 1000:
        raise ValueError(f"ERROR: Expected 1000 matches, got {matches}")

    elapsed_s = end - start
    elapsed_ms = elapsed_s * 1000.0

    print(
        f"  [IO-Bound] Files: 10000 | Matches: {matches} | Time: {elapsed_ms:.4f} ms ({elapsed_s:.6f} s)"
    )


if __name__ == "__main__":
    main()
