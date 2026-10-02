import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.IntStream;

public class Main {
    public static void main(String[] args) throws IOException {
        Path dir = Path.of("./tmp_io_test");
        Files.createDirectories(dir);

        IntStream.range(0, 10000).parallel().forEach(i -> {
            try {
                Path file = dir.resolve("file_" + i + ".txt");
                if (i % 10 == 0) {
                    Files.writeString(file, "line1\nBenchmark\nline3\n");
                } else {
                    Files.writeString(file, "line1\nline2\nline3\n");
                }
            } catch (IOException e) {
                throw new UncheckedIOException(e);
            }
        });

        long start = System.nanoTime();

        AtomicInteger matches = new AtomicInteger(0);
        try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
            List<Future<?>> futures = new ArrayList<>(10000);
            for (int i = 0; i < 10000; i++) {
                Path file = dir.resolve("file_" + i + ".txt");
                futures.add(executor.submit(() -> {
                    try {
                        String content = Files.readString(file);
                        if (content.contains("Benchmark")) {
                            matches.incrementAndGet();
                        }
                    } catch (IOException e) {
                        throw new UncheckedIOException(e);
                    }
                }));
            }
            for (Future<?> f : futures) {
                try {
                    f.get();
                } catch (InterruptedException | ExecutionException e) {
                    throw new RuntimeException(e);
                }
            }
        }

        long end = System.nanoTime();

        try (var stream = Files.walk(dir)) {
            stream.sorted(Comparator.reverseOrder())
                  .forEach(p -> {
                      try {
                          Files.delete(p);
                      } catch (IOException ignored) {}
                  });
        }

        if (matches.get() != 1000) {
            throw new IllegalStateException("ERROR: Expected 1000 matches, got " + matches.get());
        }

        double elapsedMs = (end - start) / 1_000_000.0;
        double elapsedS = elapsedMs / 1000.0;

        System.out.printf("  [IO-Bound] Files: 10000 | Matches: %d | Time: %.4f ms (%.6f s)%n",
                matches.get(), elapsedMs, elapsedS);
    }
}
