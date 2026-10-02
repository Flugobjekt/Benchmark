#include <tos.HH>

I32 main() {
  U8 *json = "{\"name\":\"Speedtest\",\"version\":1}";
  U8 *key = "\"name\":\"";
  U8 *start = strstr(json, key);
  if (start) {
    start += strlen(key);
    U8 *end = strchr(start, '"');
    if (end) {
      I32 len = end - start;
      printf("%.*s\n", len, start);
    }
  }
  return 0;
}
