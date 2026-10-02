import socket
import threading
import time

PACKET_COUNT = 100000
PACKET_SIZE = 64
TOTAL_BYTES = PACKET_COUNT * PACKET_SIZE


def server_worker(server_sock: socket.socket, end_holder: list[float]) -> None:
    conn, _ = server_sock.accept()
    received = 0
    view = memoryview(bytearray(65536))
    while received < TOTAL_BYTES:
        n = conn.recv_into(view, min(65536, TOTAL_BYTES - received))
        if not n:
            break
        received += n
    end_holder[0] = time.perf_counter()
    conn.close()
    server_sock.close()


def main() -> None:
    server_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_sock.bind(("127.0.0.1", 0))
    server_sock.listen(1)
    port = server_sock.getsockname()[1]

    end_holder: list[float] = [0.0]
    server_thread = threading.Thread(
        target=server_worker, args=(server_sock, end_holder)
    )
    server_thread.start()

    client_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_sock.connect(("127.0.0.1", port))

    packet = bytes(PACKET_SIZE)

    start = time.perf_counter()

    for _ in range(PACKET_COUNT):
        client_sock.sendall(packet)

    server_thread.join()

    client_sock.close()

    elapsed_s = end_holder[0] - start
    elapsed_ms = elapsed_s * 1000.0

    print(
        f"  [Network] Packets: 100000 | Size: 64 B | Time: {elapsed_ms:.4f} ms ({elapsed_s:.6f} s)"
    )


if __name__ == "__main__":
    main()
