function runCounter(limit: number): void {
    const start: number = performance.now();

    let count: number = 0;
    for (let i = 1; i <= limit; ++i) {
        count++;
    }

    const end: number = performance.now();
    const elapsedMs: number = end - start;
    const elapsedS: number = elapsedMs / 1000.0;

    console.log(`  [Counter] Limit: ${String(limit).padStart(11)} | Count:  ${String(count).padStart(9)} | Time: ${elapsedMs.toFixed(4).padStart(10)} ms (${elapsedS.toFixed(6).padStart(8)} s)`);

    if (count !== limit) {
        throw new Error(`ERROR: Expected ${limit}, got ${count}`);
    }
}

function main(): void {
    runCounter(1_000_000);
    runCounter(10_000_000);
    runCounter(100_000_000);
    runCounter(1_000_000_000);
}

main();

export {};
