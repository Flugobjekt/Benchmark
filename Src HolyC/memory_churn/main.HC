#include <tos.HH>

extern "c" I32 clock_gettime(I32 clk_id, cTimespec *tp);

class Node {
  I64 id;
  F64 value;
  U8 text[32];
};

I32 main() {
  cTimespec start, end;
  clock_gettime(1, &start);

  Node **nodes = malloc(5000000 * sizeof(Node *));
  if (!nodes) {
    return 1;
  }

  I64 i;
  for (i = 0; i < 5000000; ++i) {
    Node *n = malloc(sizeof(Node));
    n->id = i;
    n->value = i;
    snprintf(n->text, sizeof(n->text), "node_%ld", i);
    nodes[i] = n;
  }

  for (i = 3000000; i < 5000000; ++i) {
    free(nodes[i]);
  }

  for (i = 3000000; i < 5000000; ++i) {
    Node *n = malloc(sizeof(Node));
    n->id = i;
    n->value = i;
    snprintf(n->text, sizeof(n->text), "new_%ld", i);
    nodes[i] = n;
  }

  clock_gettime(1, &end);

  F64 elapsed_ms = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
  F64 elapsed_s = elapsed_ms / 1000.0;

  printf("  [Memory] Final Nodes: 5000000 | Time: %.4f ms (%.6f s)\n", elapsed_ms, elapsed_s);

  for (i = 0; i < 5000000; ++i) {
    free(nodes[i]);
  }
  free(nodes);

  return 0;
}
