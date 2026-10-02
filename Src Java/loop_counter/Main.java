public class Main {
    static volatile long blackhole;

    static void runCounter(long limit) {
        long start = System.nanoTime();

        long count = 0;
        for (long i = 1; i <= limit; i++) {
            count++;
            if ((count & 0xFFFFFFFL) == 0) {
                blackhole = count;
            }
        }

        long end = System.nanoTime();
        blackhole = count;

        double elapsedMs = (end - start) / 1_000_000.0;
        double elapsedS = elapsedMs / 1000.0;

        System.out.printf("  [Counter] Limit: %11d | Count:  %9d | Time: %10.4f ms (%8.6f s)%n",
                limit, count, elapsedMs, elapsedS);

        if (count != limit) {
            throw new IllegalStateException(String.format("ERROR: Expected %d, got %d", limit, count));
        }
    }

    public static void main(String[] args) {
        System.out.println("-- Loop Counter --");
        runCounter(1_000_000L);
        runCounter(10_000_000L);
        runCounter(100_000_000L);
        runCounter(1_000_000_000L);
    }
}
