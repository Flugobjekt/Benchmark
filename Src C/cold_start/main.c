#include <stdio.h>
#include <string.h>

int main(void) {
    const char *json = "{\"name\":\"Speedtest\",\"version\":1}";
    const char *key = "\"name\":\"";
    const char *start = strstr(json, key);
    if (start) {
        start += strlen(key);
        const char *end = strchr(start, '"');
        if (end) {
            printf("%.*s\n", (int)(end - start), start);
        }
    }
    return 0;
}
