#include <tos.HH>

extern "c" I32 close(I32 fd);
extern "c" U16 htons(U16 hostshort);
extern "c" U16 ntohs(U16 netshort);
extern "c" U32 inet_addr(U8 *cp);
extern "c" I32 clock_gettime(I32 clk_id, cTimespec *tp);

class ServerArgs {
  I32 server_fd;
  cTimespec end_time;
};

U0 server_thread(ServerArgs *args) {
  sockaddr_in client_addr;
  I64 client_len = sizeof(sockaddr_in);
  I32 conn_fd = accept(args->server_fd, (&client_addr)(sockaddr*), &client_len);

  U8 buf[64];
  I64 total_bytes = 0;
  I64 expected = 100000 * 64;
  while (total_bytes < expected) {
    I64 n = recv(conn_fd, buf, sizeof(buf), 0);
    if (n <= 0) {
      break;
    }
    total_bytes += n;
  }
  clock_gettime(1, &args->end_time);
  close(conn_fd);
}

I32 main() {
  I32 server_fd = socket(AF_INET, SOCK_STREAM, 0);
  sockaddr_in addr;
  MemSet(&addr, 0, sizeof(sockaddr_in));
  U16 *family_ptr = (&addr)(U16*);
  *family_ptr = AF_INET;
  addr.sin_port = 0;
  addr.sin_addr.s_addr = inet_addr("127.0.0.1");

  bind(server_fd, (&addr)(sockaddr*), sizeof(sockaddr_in));
  listen(server_fd, 1);

  I64 len = sizeof(sockaddr_in);
  getsockname(server_fd, (&addr)(sockaddr*), &len);
  U16 port = ntohs(addr.sin_port);

  ServerArgs sargs;
  sargs.server_fd = server_fd;

  pthread_t *thread = NULL;
  pthread_create(&thread, NULL, &server_thread, &sargs);

  I32 client_fd = socket(AF_INET, SOCK_STREAM, 0);
  sockaddr_in srv_addr;
  MemSet(&srv_addr, 0, sizeof(sockaddr_in));
  U16 *srv_family_ptr = (&srv_addr)(U16*);
  *srv_family_ptr = AF_INET;
  srv_addr.sin_port = htons(port);
  srv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

  connect(client_fd, (&srv_addr)(sockaddr*), sizeof(sockaddr_in));

  cTimespec start;
  clock_gettime(1, &start);

  U8 packet[64];
  MemSet(packet, 0, 64);
  I64 i;
  for (i = 0; i < 100000; ++i) {
    I64 sent = 0;
    while (sent < 64) {
      I64 n = send(client_fd, packet + sent, 64 - sent, 0);
      if (n <= 0) {
        break;
      }
      sent += n;
    }
  }

  pthread_join(thread, NULL);
  close(client_fd);
  close(server_fd);

  F64 elapsed_ms = (sargs.end_time.tv_sec - start.tv_sec) * 1000.0 + (sargs.end_time.tv_nsec - start.tv_nsec) / 1000000.0;
  F64 elapsed_s = elapsed_ms / 1000.0;

  printf("  [Network] Packets: 100000 | Size: 64 B | Time: %.4f ms (%.6f s)\n",
         elapsed_ms, elapsed_s);
  return 0;
}
