function runSieve(limit, expected) {
    const numOdds = limit >> 1;
    const isPrime = new Uint8Array(numOdds);
    isPrime.fill(1);
    if (numOdds > 0) {
        isPrime[0] = 0;
    }

    const start = performance.now();

    for (let i = 1; (2 * i + 1) * (2 * i + 1) < limit; ++i) {
        if (isPrime[i] === 1) {
            const p = 2 * i + 1;
            let j = 2 * i * (i + 1);
            const p4 = 4 * p;

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

    const end = performance.now();
    const elapsedMs = end - start;
    const elapsedS = elapsedMs / 1000.0;

    let count = 1;
    for (let i = 1; i < numOdds; ++i) {
        count += isPrime[i];
    }

    console.log(`  [Sieve]   Limit: ${String(limit).padStart(11)} | Primes: ${String(count).padStart(9)} | Time: ${elapsedMs.toFixed(4).padStart(10)} ms (${elapsedS.toFixed(6).padStart(8)} s)`);

    if (count !== expected) {
        throw new Error(`ERROR: Expected ${expected}, got ${count}`);
    }
}

function main() {
    runSieve(1_000_000, 78_498);
    runSieve(10_000_000, 664_579);
    runSieve(100_000_000, 5_761_455);
    runSieve(1_000_000_000, 50_847_534);
}

main();
