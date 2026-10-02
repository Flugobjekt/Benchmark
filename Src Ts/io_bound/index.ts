import fs from "node:fs/promises";

async function main(): Promise<void> {
    const dir: string = "./tmp_io_test";
    await fs.mkdir(dir, { recursive: true });

    try {
        const lineNormal: string = "First line of text\nSecond line of text\nThird line of text\n";
        const lineMatch: string = "First line of text\nSecond line with Benchmark\nThird line of text\n";

        const writeTasks: Promise<number>[] = [];
        for (let i = 0; i < 10000; i++) {
            const content: string = (i % 10 === 0) ? lineMatch : lineNormal;
            writeTasks.push(Bun.write(`${dir}/file_${i}.txt`, content));
        }
        await Promise.all(writeTasks);

        let matches: number = 0;
        const start: number = performance.now();
        const readTasks: Promise<void>[] = [];
        for (let i = 0; i < 10000; i++) {
            readTasks.push(
                Bun.file(`${dir}/file_${i}.txt`).text().then((text: string) => {
                    if (text.includes("Benchmark")) {
                        matches++;
                    }
                })
            );
        }
        await Promise.all(readTasks);
        const end: number = performance.now();

        const elapsedMs: number = end - start;
        const elapsedS: number = elapsedMs / 1000.0;

        console.log(`  [IO-Bound] Files: 10000 | Matches: ${matches} | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
    } finally {
        await fs.rm(dir, { recursive: true, force: true });
    }
}

main();
