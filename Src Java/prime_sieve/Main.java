import java.util.Arrays;

public class Main {
    static void runSieve(int limit, int expected) {
        int numOdds = limit / 2;
        byte[] isPrime = new byte[numOdds];
        Arrays.fill(isPrime, (byte) 1);
        if (numOdds > 0) {
            isPrime[0] = 0;
        }

        long start = System.nanoTime();

        for (int i = 1; (2 * i + 1) * (2 * i + 1) < limit; i++) {
            if (isPrime[i] != 0) {
                int p = 2 * i + 1;
                int j = 2 * i * (i + 1);
                int p4 = 4 * p;

                while (j + p4 <= numOdds) {
                    isPrime[j] = 0;
                    isPrime[j + p] = 0;
                    isPrime[j + 2 * p] = 0;
                    isPrime[j + 3 * p] = 0;
                    j += p4;
                }

                while (j < numOdds) {
                    isPrime[j] = 0;
                    j += p;
                }
            }
        }

        long end = System.nanoTime();
        double elapsedMs = (end - start) / 1_000_000.0;
        double elapsedS = elapsedMs / 1000.0;

        int count = 1;
        for (int i = 1; i < numOdds; i++) {
            count += isPrime[i];
        }

        System.out.printf("  [Sieve]   Limit: %11d | Primes: %9d | Time: %10.4f ms (%8.6f s)%n",
                limit, count, elapsedMs, elapsedS);

        if (count != expected) {
            throw new IllegalStateException(String.format("ERROR: Expected %d, got %d", expected, count));
        }
    }

    public static void main(String[] args) {
        System.out.println("-- Prime Sieve --");
        runSieve(1_000_000, 78_498);
        runSieve(10_000_000, 664_579);
        runSieve(100_000_000, 5_761_455);
        runSieve(1_000_000_000, 50_847_534);
    }
}
