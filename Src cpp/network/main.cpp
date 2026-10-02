#include <iostream>
#include <vector>
#include <thread>
#include <chrono>
#include <iomanip>
#include <cstdint>
#include <cstring>
#include <cstdlib>
#include <mutex>
#include <condition_variable>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>

constexpr int NUM_PACKETS = 100000;
constexpr int PACKET_SIZE = 64;
constexpr size_t TOTAL_BYTES = static_cast<size_t>(NUM_PACKETS) * PACKET_SIZE;
constexpr size_t CHUNK_SIZE = 65536;

struct ServerContext {
    std::mutex mtx;
    std::condition_variable cv;
    uint16_t port = 0;
    std::chrono::steady_clock::time_point end_time;
};

static inline void validate_packet(const uint8_t* pkt, uint32_t expected) {
    uint32_t seq = static_cast<uint32_t>(pkt[0]) |
                   (static_cast<uint32_t>(pkt[1]) << 8) |
                   (static_cast<uint32_t>(pkt[2]) << 16) |
                   (static_cast<uint32_t>(pkt[3]) << 24);
    if (seq != expected) {
        std::cerr << "Packet sequence mismatch: expected " << expected << ", got " << seq << "\n";
        std::exit(1);
    }
    uint8_t expected_byte = static_cast<uint8_t>(expected & 0xFF);
    for (int i = 4; i < PACKET_SIZE; ++i) {
        if (pkt[i] != expected_byte) {
            std::cerr << "Packet payload mismatch at byte " << i << "\n";
            std::exit(1);
        }
    }
}

static void server_worker(ServerContext& ctx) {
    int listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (listen_fd < 0) {
        std::perror("socket");
        std::exit(1);
    }

    int opt = 1;
    setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    sockaddr_in serv_addr{};
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    serv_addr.sin_port = 0;

    if (bind(listen_fd, reinterpret_cast<sockaddr*>(&serv_addr), sizeof(serv_addr)) < 0) {
        std::perror("bind");
        std::exit(1);
    }

    if (listen(listen_fd, 1) < 0) {
        std::perror("listen");
        std::exit(1);
    }

    socklen_t addr_len = sizeof(serv_addr);
    if (getsockname(listen_fd, reinterpret_cast<sockaddr*>(&serv_addr), &addr_len) < 0) {
        std::perror("getsockname");
        std::exit(1);
    }

    uint16_t port = ntohs(serv_addr.sin_port);

    {
        std::lock_guard<std::mutex> lock(ctx.mtx);
        ctx.port = port;
    }
    ctx.cv.notify_one();

    int client_fd = accept(listen_fd, nullptr, nullptr);
    if (client_fd < 0) {
        std::perror("accept");
        std::exit(1);
    }

    setsockopt(client_fd, IPPROTO_TCP, TCP_NODELAY, &opt, sizeof(opt));

    uint8_t recv_buf[CHUNK_SIZE];
    uint8_t packet_buf[PACKET_SIZE];
    size_t packet_rem = 0;
    uint32_t packets_received = 0;
    size_t total_received = 0;

    while (total_received < TOTAL_BYTES) {
        ssize_t n = recv(client_fd, recv_buf, sizeof(recv_buf), 0);
        if (n <= 0) {
            break;
        }

        size_t offset = 0;
        size_t bytes_left = static_cast<size_t>(n);

        while (offset < bytes_left) {
            if (packet_rem > 0) {
                size_t needed = PACKET_SIZE - packet_rem;
                size_t avail = bytes_left - offset;
                size_t to_copy = (avail < needed) ? avail : needed;
                std::memcpy(packet_buf + packet_rem, recv_buf + offset, to_copy);
                packet_rem += to_copy;
                offset += to_copy;

                if (packet_rem == PACKET_SIZE) {
                    validate_packet(packet_buf, packets_received);
                    packets_received++;
                    packet_rem = 0;
                }
            } else if (bytes_left - offset >= PACKET_SIZE) {
                validate_packet(recv_buf + offset, packets_received);
                packets_received++;
                offset += PACKET_SIZE;
            } else {
                size_t to_copy = bytes_left - offset;
                std::memcpy(packet_buf, recv_buf + offset, to_copy);
                packet_rem = to_copy;
                offset += to_copy;
            }
        }

        total_received += static_cast<size_t>(n);
        if (total_received == TOTAL_BYTES) {
            ctx.end_time = std::chrono::steady_clock::now();
            break;
        }
    }

    close(client_fd);
    close(listen_fd);
}

int main() {
    std::vector<uint8_t> send_buf(TOTAL_BYTES);

    for (uint32_t i = 0; i < NUM_PACKETS; ++i) {
        size_t offset = static_cast<size_t>(i) * PACKET_SIZE;
        send_buf[offset + 0] = static_cast<uint8_t>(i & 0xFF);
        send_buf[offset + 1] = static_cast<uint8_t>((i >> 8) & 0xFF);
        send_buf[offset + 2] = static_cast<uint8_t>((i >> 16) & 0xFF);
        send_buf[offset + 3] = static_cast<uint8_t>((i >> 24) & 0xFF);
        std::memset(send_buf.data() + offset + 4, static_cast<uint8_t>(i & 0xFF), PACKET_SIZE - 4);
    }

    ServerContext ctx;
    std::thread server_thr(server_worker, std::ref(ctx));

    uint16_t port = 0;
    {
        std::unique_lock<std::mutex> lock(ctx.mtx);
        ctx.cv.wait(lock, [&ctx]() { return ctx.port != 0; });
        port = ctx.port;
    }

    int client_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (client_sock < 0) {
        std::perror("socket");
        std::exit(1);
    }

    int opt = 1;
    setsockopt(client_sock, IPPROTO_TCP, TCP_NODELAY, &opt, sizeof(opt));

    sockaddr_in serv_addr{};
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    serv_addr.sin_port = htons(port);

    if (connect(client_sock, reinterpret_cast<sockaddr*>(&serv_addr), sizeof(serv_addr)) < 0) {
        std::perror("connect");
        std::exit(1);
    }

    auto start_time = std::chrono::steady_clock::now();

    size_t total_sent = 0;
    while (total_sent < TOTAL_BYTES) {
        size_t chunk = TOTAL_BYTES - total_sent;
        if (chunk > CHUNK_SIZE) {
            chunk = CHUNK_SIZE;
        }
        ssize_t n = send(client_sock, send_buf.data() + total_sent, chunk, 0);
        if (n <= 0) {
            std::perror("send");
            std::exit(1);
        }
        total_sent += static_cast<size_t>(n);
    }

    shutdown(client_sock, SHUT_WR);
    server_thr.join();
    close(client_sock);

    std::chrono::duration<double, std::milli> elapsed_ms = ctx.end_time - start_time;
    std::chrono::duration<double> elapsed_s = ctx.end_time - start_time;

    std::cout << "  [Network] Packets: " << NUM_PACKETS
              << " | Size: " << PACKET_SIZE << " B | Time: "
              << std::fixed << std::setprecision(4) << elapsed_ms.count() << " ms"
              << " (" << std::setprecision(6) << elapsed_s.count() << " s)\n";

    return 0;
}
