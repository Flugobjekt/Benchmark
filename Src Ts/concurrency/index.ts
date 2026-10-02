async function main(): Promise<void> {
    const numTasks: number = 500;
    const delay: number = 200;
    const tasks: Promise<unknown>[] = [];

    const start: number = performance.now();
    for (let i = 0; i < numTasks; i++) {
        tasks.push(new Promise(r => setTimeout(r, delay)));
    }
    await Promise.all(tasks);
    const end: number = performance.now();

    const elapsedMs: number = end - start;
    const elapsedS = elapsedMs / 1000.0;

    console.log(`  [Concurrency] Tasks: ${numTasks} | Delay: ${delay} ms | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
}

main();

export {};
