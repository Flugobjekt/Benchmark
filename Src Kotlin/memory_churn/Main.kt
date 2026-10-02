import java.util.ArrayList
import java.util.Locale

class Node(val id: Int, val value: Double, val text: String)

fun main() {
    val start = System.nanoTime()

    val nodes = ArrayList<Node>(5_000_000)
    for (i in 0 until 5_000_000) {
        nodes.add(Node(i, i * 1.5, "node"))
    }

    for (i in 0 until 2_000_000) {
        nodes.removeAt(nodes.size - 1)
    }

    for (i in 5_000_000 until 7_000_000) {
        nodes.add(Node(i, i * 1.5, "node"))
    }

    val end = System.nanoTime()

    if (nodes.size != 5_000_000 || nodes[0].id != 0) {
        throw IllegalStateException("ERROR: Expected 5000000 nodes, got ${nodes.size}")
    }

    val elapsedMs = (end - start) / 1_000_000.0
    val elapsedS = elapsedMs / 1000.0

    System.out.printf(
        Locale.US,
        "  [Memory] Final Nodes: %d | Time: %.4f ms (%.6f s)%n",
        nodes.size, elapsedMs, elapsedS
    )
}
