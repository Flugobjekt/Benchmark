#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>

#define NUM_PACKETS 100000
#define PACKET_SIZE 64
#define TOTAL_BYTES ((size_t)NUM_PACKETS * PACKET_SIZE)
#define CHUNK_SIZE 65536

typedef struct {
    pthread_mutex_t lock;
    pthread_cond_t cond;
    uint16_t port;
    struct timespec end_time;
} ServerContext;

static inline void validate_packet(const uint8_t *pkt, uint32_t expected) {
    uint32_t seq = (uint32_t)pkt[0] | ((uint32_t)pkt[1] << 8) | ((uint32_t)pkt[2] << 16) | ((uint32_t)pkt[3] << 24);
    if (seq != expected) {
        fprintf(stderr, "Packet sequence mismatch: expected %u, got %u\n", expected, seq);
        exit(1);
    }
    uint8_t expected_byte = (uint8_t)(expected & 0xFF);
    for (int i = 4; i < PACKET_SIZE; ++i) {
        if (pkt[i] != expected_byte) {
            fprintf(stderr, "Packet payload mismatch at byte %d\n", i);
            exit(1);
        }
    }
}

static void* server_thread(void *arg) {
    ServerContext *ctx = (ServerContext*)arg;
    int listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (listen_fd < 0) {
        perror("socket");
        exit(1);
    }

    int opt = 1;
    setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    serv_addr.sin_port = 0;

    if (bind(listen_fd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("bind");
        exit(1);
    }

    if (listen(listen_fd, 1) < 0) {
        perror("listen");
        exit(1);
    }

    socklen_t addr_len = sizeof(serv_addr);
    if (getsockname(listen_fd, (struct sockaddr*)&serv_addr, &addr_len) < 0) {
        perror("getsockname");
        exit(1);
    }

    uint16_t port = ntohs(serv_addr.sin_port);

    pthread_mutex_lock(&ctx->lock);
    ctx->port = port;
    pthread_cond_signal(&ctx->cond);
    pthread_mutex_unlock(&ctx->lock);

    int client_fd = accept(listen_fd, NULL, NULL);
    if (client_fd < 0) {
        perror("accept");
        exit(1);
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
        size_t bytes_left = (size_t)n;

        while (offset < bytes_left) {
            if (packet_rem > 0) {
                size_t needed = PACKET_SIZE - packet_rem;
                size_t avail = bytes_left - offset;
                size_t to_copy = (avail < needed) ? avail : needed;
                memcpy(packet_buf + packet_rem, recv_buf + offset, to_copy);
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
                memcpy(packet_buf, recv_buf + offset, to_copy);
                packet_rem = to_copy;
                offset += to_copy;
            }
        }

        total_received += (size_t)n;
        if (total_received == TOTAL_BYTES) {
            clock_gettime(CLOCK_MONOTONIC, &ctx->end_time);
            break;
        }
    }

    close(client_fd);
    close(listen_fd);
    return NULL;
}

int main(void) {
    uint8_t *send_buf = (uint8_t*)malloc(TOTAL_BYTES);
    if (!send_buf) {
        fprintf(stderr, "Failed to allocate send buffer\n");
        return 1;
    }

    for (uint32_t i = 0; i < NUM_PACKETS; ++i) {
        size_t offset = (size_t)i * PACKET_SIZE;
        send_buf[offset + 0] = (uint8_t)(i & 0xFF);
        send_buf[offset + 1] = (uint8_t)((i >> 8) & 0xFF);
        send_buf[offset + 2] = (uint8_t)((i >> 16) & 0xFF);
        send_buf[offset + 3] = (uint8_t)((i >> 24) & 0xFF);
        memset(send_buf + offset + 4, (uint8_t)(i & 0xFF), PACKET_SIZE - 4);
    }

    ServerContext ctx;
    memset(&ctx, 0, sizeof(ctx));
    pthread_mutex_init(&ctx.lock, NULL);
    pthread_cond_init(&ctx.cond, NULL);

    pthread_t server_tid;
    if (pthread_create(&server_tid, NULL, server_thread, &ctx) != 0) {
        perror("pthread_create");
        return 1;
    }

    pthread_mutex_lock(&ctx.lock);
    while (ctx.port == 0) {
        pthread_cond_wait(&ctx.cond, &ctx.lock);
    }
    uint16_t port = ctx.port;
    pthread_mutex_unlock(&ctx.lock);

    int client_sock = socket(AF_INET, SOCK_STREAM, 0);
    if (client_sock < 0) {
        perror("socket");
        return 1;
    }

    int opt = 1;
    setsockopt(client_sock, IPPROTO_TCP, TCP_NODELAY, &opt, sizeof(opt));

    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    serv_addr.sin_port = htons(port);

    if (connect(client_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("connect");
        return 1;
    }

    struct timespec start_time;
    clock_gettime(CLOCK_MONOTONIC, &start_time);

    size_t total_sent = 0;
    while (total_sent < TOTAL_BYTES) {
        size_t chunk = TOTAL_BYTES - total_sent;
        if (chunk > CHUNK_SIZE) {
            chunk = CHUNK_SIZE;
        }
        ssize_t n = send(client_sock, send_buf + total_sent, chunk, 0);
        if (n <= 0) {
            perror("send");
            return 1;
        }
        total_sent += (size_t)n;
    }

    shutdown(client_sock, SHUT_WR);
    pthread_join(server_tid, NULL);
    close(client_sock);
    free(send_buf);
    pthread_mutex_destroy(&ctx.lock);
    pthread_cond_destroy(&ctx.cond);

    double elapsed_ms = (ctx.end_time.tv_sec - start_time.tv_sec) * 1000.0 +
                        (ctx.end_time.tv_nsec - start_time.tv_nsec) / 1000000.0;
    double elapsed_s = elapsed_ms / 1000.0;

    printf("  [Network] Packets: %d | Size: %d B | Time: %.4f ms (%.6f s)\n",
           NUM_PACKETS, PACKET_SIZE, elapsed_ms, elapsed_s);

    return 0;
}
