import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Main {
    public static void main(String[] args) {
        long start = System.nanoTime();

        try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
            List<Future<?>> futures = new ArrayList<>(500);
            for (int i = 0; i < 500; i++) {
                futures.add(executor.submit(() -> {
                    try {
                        Thread.sleep(200);
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
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

        double elapsedMs = (end - start) / 1_000_000.0;
        double elapsedS = elapsedMs / 1000.0;

        System.out.printf("  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: %.4f ms (%.6f s)%n",
                elapsedMs, elapsedS);
    }
}
