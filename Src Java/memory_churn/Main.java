import java.util.ArrayList;

public class Main {
    static final class Node {
        final int id;
        final double value;
        final String name;

        Node(int id, double value, String name) {
            this.id = id;
            this.value = value;
            this.name = name;
        }
    }

    public static void main(String[] args) {
        long start = System.nanoTime();

        ArrayList<Node> nodes = new ArrayList<>(5_000_000);
        for (int i = 0; i < 5_000_000; i++) {
            nodes.add(new Node(i, i * 1.5, "node"));
        }

        for (int i = 0; i < 2_000_000; i++) {
            nodes.remove(nodes.size() - 1);
        }

        for (int i = 5_000_000; i < 7_000_000; i++) {
            nodes.add(new Node(i, i * 1.5, "node"));
        }

        long end = System.nanoTime();

        if (nodes.size() != 5_000_000 || nodes.get(0) == null) {
            throw new IllegalStateException("ERROR: Expected 5000000 nodes, got " + nodes.size());
        }

        double elapsedMs = (end - start) / 1_000_000.0;
        double elapsedS = elapsedMs / 1000.0;

        System.out.printf("  [Memory] Final Nodes: %d | Time: %.4f ms (%.6f s)%n",
                nodes.size(), elapsedMs, elapsedS);
    }
}
