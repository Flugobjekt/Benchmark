import java.util.Arrays
import java.util.Locale

fun runSieve(limit: Int, expected: Int) {
    val numOdds = limit / 2
    val isPrime = ByteArray(numOdds)
    Arrays.fill(isPrime, 1.toByte())
    if (numOdds > 0) {
        isPrime[0] = 0
    }

    val start = System.nanoTime()

    var i = 1
    while ((2L * i + 1) * (2L * i + 1) < limit) {
        if (isPrime[i].toInt() != 0) {
            val p = 2 * i + 1
            var j = 2 * i * (i + 1)
            val p4 = 4 * p

            while (j + p4 <= numOdds) {
                isPrime[j] = 0
                isPrime[j + p] = 0
                isPrime[j + 2 * p] = 0
                isPrime[j + 3 * p] = 0
                j += p4
            }

            while (j < numOdds) {
                isPrime[j] = 0
                j += p
            }
        }
        i++
    }

    val end = System.nanoTime()
    val elapsedMs = (end - start) / 1_000_000.0
    val elapsedS = elapsedMs / 1000.0

    var count = 1
    for (idx in 1 until numOdds) {
        count += isPrime[idx].toInt()
    }

    System.out.printf(
        Locale.US,
        "  [Sieve]   Limit: %11d | Primes: %9d | Time: %10.4f ms (%8.6f s)%n",
        limit, count, elapsedMs, elapsedS
    )

    if (count != expected) {
        throw IllegalStateException("ERROR: Expected $expected, got $count")
    }
}

fun main() {
    runSieve(1_000_000, 78_498)
    runSieve(10_000_000, 664_579)
    runSieve(100_000_000, 5_761_455)
    runSieve(1_000_000_000, 50_847_534)
}
