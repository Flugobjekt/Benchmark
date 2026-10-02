#include <tos.HH>

extern "c" I32 clock_gettime(I32 clk_id, cTimespec *tp);

I32 main() {
  mkdir("./tmp_io_test", 511);
  U8 path[64];
  U8 *match_data = "Line 1: Sample data\nLine 2: Benchmark\nLine 3: End of file\n";
  U8 *nomatch_data = "Line 1: Sample data\nLine 2: Nothing special\nLine 3: End of file\n";
  I64 match_len = strlen(match_data);
  I64 nomatch_len = strlen(nomatch_data);

  I64 i;
  for (i = 0; i < 10000; ++i) {
    snprintf(path, sizeof(path), "./tmp_io_test/file_%ld.txt", i);
    I32 fd = open(path, 1 | 64 | 512, 420);
    if (fd >= 0) {
      if (i % 10 == 0) {
        write(fd, match_data, match_len);
      } else {
        write(fd, nomatch_data, nomatch_len);
      }
      close(fd);
    }
  }

  cTimespec start, end;
  clock_gettime(1, &start);

  I64 matches = 0;
  U8 buf[256];
  for (i = 0; i < 10000; ++i) {
    snprintf(path, sizeof(path), "./tmp_io_test/file_%ld.txt", i);
    I32 fd = open(path, 0);
    if (fd >= 0) {
      I64 n = read(fd, buf, sizeof(buf) - 1);
      if (n > 0) {
        buf[n] = 0;
        if (strstr(buf, "Benchmark") != NULL) {
          matches++;
        }
      }
      close(fd);
    }
  }

  clock_gettime(1, &end);

  for (i = 0; i < 10000; ++i) {
    snprintf(path, sizeof(path), "./tmp_io_test/file_%ld.txt", i);
    unlink(path);
  }
  rmdir("./tmp_io_test");

  F64 elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
  F64 elapsed_s = elapsed_ms / 1000.0;

  printf("  [IO-Bound] Files: 10000 | Matches: %ld | Time: %.4f ms (%.6f s)\n",
         matches, elapsed_ms, elapsed_s);
  return 0;
}
