async function main() {
    const numTasks = 500;
    const delay = 200;
    const tasks = [];

    const start = performance.now();
    for (let i = 0; i < numTasks; i++) {
        tasks.push(new Promise(r => setTimeout(r, delay)));
    }
    await Promise.all(tasks);
    const end = performance.now();

    const elapsedMs = end - start;
    const elapsedS = elapsedMs / 1000.0;

    console.log(`  [Concurrency] Tasks: ${numTasks} | Delay: ${delay} ms | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
}

main();
