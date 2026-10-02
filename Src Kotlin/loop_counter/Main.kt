import java.util.Locale

@Volatile
var sink: Long = 0

fun runCounter(limit: Long) {
    val start = System.nanoTime()

    var count = 0L
    for (i in 1..limit) {
        count++
        if ((count and 0xFFFFFFFL) == 0L) {
            sink = count
        }
    }

    val end = System.nanoTime()
    sink = count

    val elapsedMs = (end - start) / 1_000_000.0
    val elapsedS = elapsedMs / 1000.0

    System.out.printf(
        Locale.US,
        "  [Counter] Limit: %11d | Count:  %9d | Time: %10.4f ms (%8.6f s)%n",
        limit, count, elapsedMs, elapsedS
    )

    if (count != limit) {
        throw IllegalStateException("ERROR: Expected $limit, got $count")
    }
}

fun main() {
    runCounter(1_000_000L)
    runCounter(10_000_000L)
    runCounter(100_000_000L)
    runCounter(1_000_000_000L)
}
