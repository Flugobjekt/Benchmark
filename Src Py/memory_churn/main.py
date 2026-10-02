import time


class Node:
    __slots__ = ("id", "name", "value")

    def __init__(self, id: int, value: float, name: str) -> None:
        self.id = id
        self.value = value
        self.name = name


def main() -> None:
    start = time.perf_counter()

    nodes = [Node(i, i * 1.5, "node") for i in range(5_000_000)]

    for _ in range(2_000_000):
        nodes.pop()

    for i in range(5_000_000, 7_000_000):
        nodes.append(Node(i, i * 1.5, "node"))

    end = time.perf_counter()

    if len(nodes) != 5_000_000:
        raise ValueError(f"ERROR: Expected 5000000 nodes, got {len(nodes)}")

    elapsed_s = end - start
    elapsed_ms = elapsed_s * 1000.0

    print(
        f"  [Memory] Final Nodes: {len(nodes)} | Time: {elapsed_ms:.4f} ms ({elapsed_s:.6f} s)"
    )


if __name__ == "__main__":
    main()
