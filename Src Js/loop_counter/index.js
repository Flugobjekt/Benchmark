function runCounter(limit) {
    const start = performance.now();

    let count = 0;
    for (let i = 1; i <= limit; ++i) {
        count++;
    }

    const end = performance.now();
    const elapsedMs = end - start;
    const elapsedS = elapsedMs / 1000.0;

    console.log(`  [Counter] Limit: ${String(limit).padStart(11)} | Count:  ${String(count).padStart(9)} | Time: ${elapsedMs.toFixed(4).padStart(10)} ms (${elapsedS.toFixed(6).padStart(8)} s)`);

    if (count !== limit) {
        throw new Error(`ERROR: Expected ${limit}, got ${count}`);
    }
}

function main() {
    runCounter(1_000_000);
    runCounter(10_000_000);
    runCounter(100_000_000);
    runCounter(1_000_000_000);
}

main();
