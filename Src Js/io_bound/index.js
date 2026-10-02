import fs from "node:fs/promises";

async function main() {
    const dir = "./tmp_io_test";
    await fs.mkdir(dir, { recursive: true });

    try {
        const lineNormal = "First line of text\nSecond line of text\nThird line of text\n";
        const lineMatch = "First line of text\nSecond line with Benchmark\nThird line of text\n";

        const writeTasks = [];
        for (let i = 0; i < 10000; i++) {
            const content = (i % 10 === 0) ? lineMatch : lineNormal;
            writeTasks.push(Bun.write(`${dir}/file_${i}.txt`, content));
        }
        await Promise.all(writeTasks);

        let matches = 0;
        const start = performance.now();
        const readTasks = [];
        for (let i = 0; i < 10000; i++) {
            readTasks.push(
                Bun.file(`${dir}/file_${i}.txt`).text().then(text => {
                    if (text.includes("Benchmark")) {
                        matches++;
                    }
                })
            );
        }
        await Promise.all(readTasks);
        const end = performance.now();

        const elapsedMs = end - start;
        const elapsedS = elapsedMs / 1000.0;

        console.log(`  [IO-Bound] Files: 10000 | Matches: ${matches} | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
    } finally {
        await fs.rm(dir, { recursive: true, force: true });
    }
}

main();
