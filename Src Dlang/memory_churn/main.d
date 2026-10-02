import core.stdc.stdio : snprintf;
import core.stdc.stdlib : malloc, free, exit;
import core.time : MonoTime, Duration;
import std.stdio : writefln;

struct Node {
    int id;
    double value;
    char[32] text;
}

void main() {
    MonoTime start = MonoTime.currTime;

    Node** nodes = cast(Node**) malloc(5_000_000 * (Node*).sizeof);
    if (nodes is null) {
        exit(1);
    }

    foreach (i; 0 .. 5_000_000) {
        Node* n = cast(Node*) malloc(Node.sizeof);
        if (n is null) {
            exit(1);
        }
        n.id = i;
        n.value = cast(double) i;
        snprintf(n.text.ptr, n.text.sizeof, "node_%d", i);
        nodes[i] = n;
    }

    foreach (i; 3_000_000 .. 5_000_000) {
        free(nodes[i]);
    }

    foreach (i; 3_000_000 .. 5_000_000) {
        Node* n = cast(Node*) malloc(Node.sizeof);
        if (n is null) {
            exit(1);
        }
        n.id = i;
        n.value = cast(double) i;
        snprintf(n.text.ptr, n.text.sizeof, "new_%d", i);
        nodes[i] = n;
    }

    MonoTime end = MonoTime.currTime;

    Duration elapsed = end - start;
    double elapsedMs = cast(double) elapsed.total!"nsecs" / 1_000_000.0;
    double elapsedS = cast(double) elapsed.total!"nsecs" / 1_000_000_000.0;

    writefln("  [Memory] Final Nodes: 5000000 | Time: %.4f ms (%.6f s)",
             elapsedMs, elapsedS);

    foreach (i; 0 .. 5_000_000) {
        free(nodes[i]);
    }
    free(nodes);
}
