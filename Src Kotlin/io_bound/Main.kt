import java.nio.file.Files
import java.nio.file.Path
import java.util.Comparator
import java.util.Locale
import java.util.concurrent.Callable
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicInteger
import java.util.stream.IntStream

fun main() {
    val dir = Path.of("./tmp_io_test")
    Files.createDirectories(dir)

    IntStream.range(0, 10000).parallel().forEach { i ->
        val file = dir.resolve("file_$i.txt")
        if (i % 10 == 0) {
            Files.writeString(file, "line1\nBenchmark\nline3\n")
        } else {
            Files.writeString(file, "line1\nline2\nline3\n")
        }
    }

    val start = System.nanoTime()

    val matches = AtomicInteger(0)
    Executors.newVirtualThreadPerTaskExecutor().use { executor ->
        val tasks = (0 until 10000).map { i ->
            val file = dir.resolve("file_$i.txt")
            Callable {
                val content = Files.readString(file)
                if (content.contains("Benchmark")) {
                    matches.incrementAndGet()
                }
            }
        }
        executor.invokeAll(tasks)
    }

    val end = System.nanoTime()

    Files.walk(dir)
        .sorted(Comparator.reverseOrder())
        .forEach { p ->
            try {
                Files.delete(p)
            } catch (ignored: Exception) {}
        }

    val matchCount = matches.get()
    if (matchCount != 1000) {
        throw IllegalStateException("ERROR: Expected 1000 matches, got $matchCount")
    }

    val elapsedMs = (end - start) / 1_000_000.0
    val elapsedS = elapsedMs / 1000.0

    System.out.printf(
        Locale.US,
        "  [IO-Bound] Files: 10000 | Matches: %d | Time: %.4f ms (%.6f s)%n",
        matchCount, elapsedMs, elapsedS
    )
}
