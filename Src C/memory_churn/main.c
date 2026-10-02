#include <stdio.h>
#include <stdlib.h>
#include <time.h>

typedef struct Node {
    int id;
    double value;
    char text[32];
} Node;

int main(void) {
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    Node **nodes = (Node **)malloc(5000000 * sizeof(Node *));
    if (!nodes) {
        return 1;
    }

    for (int i = 0; i < 5000000; ++i) {
        Node *n = (Node *)malloc(sizeof(Node));
        n->id = i;
        n->value = (double)i;
        snprintf(n->text, sizeof(n->text), "node_%d", i);
        nodes[i] = n;
    }

    for (int i = 3000000; i < 5000000; ++i) {
        free(nodes[i]);
    }

    for (int i = 3000000; i < 5000000; ++i) {
        Node *n = (Node *)malloc(sizeof(Node));
        n->id = i;
        n->value = (double)i;
        snprintf(n->text, sizeof(n->text), "new_%d", i);
        nodes[i] = n;
    }

    clock_gettime(CLOCK_MONOTONIC, &end);

    double elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
    double elapsed_s = elapsed_ms / 1000.0;
    printf("  [Memory] Final Nodes: 5000000 | Time: %.4f ms (%.6f s)\n", elapsed_ms, elapsed_s);

    for (int i = 0; i < 5000000; ++i) {
        free(nodes[i]);
    }
    free(nodes);

    return 0;
}
