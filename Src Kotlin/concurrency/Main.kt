import java.util.Locale
import java.util.concurrent.Callable
import java.util.concurrent.Executors

fun main() {
    val start = System.nanoTime()

    Executors.newVirtualThreadPerTaskExecutor().use { executor ->
        val tasks = (0 until 500).map {
            Callable {
                try {
                    Thread.sleep(200)
                } catch (e: InterruptedException) {
                    Thread.currentThread().interrupt()
                }
            }
        }
        executor.invokeAll(tasks)
    }

    val end = System.nanoTime()

    val elapsedMs = (end - start) / 1_000_000.0
    val elapsedS = elapsedMs / 1000.0

    System.out.printf(
        Locale.US,
        "  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: %.4f ms (%.6f s)%n",
        elapsedMs, elapsedS
    )
}
