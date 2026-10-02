import asyncio
import time


async def task() -> None:
    await asyncio.sleep(0.2)


async def run_benchmark() -> None:
    start = time.perf_counter()
    await asyncio.gather(*(task() for _ in range(500)))
    end = time.perf_counter()

    elapsed_s = end - start
    elapsed_ms = elapsed_s * 1000.0

    print(
        f"  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: {elapsed_ms:.4f} ms ({elapsed_s:.6f} s)"
    )


def main() -> None:
    asyncio.run(run_benchmark())


if __name__ == "__main__":
    main()
