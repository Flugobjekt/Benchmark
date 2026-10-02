class Node {
    id: number;
    value: number;
    name: string;

    constructor(id: number, value: number, name: string) {
        this.id = id;
        this.value = value;
        this.name = name;
    }
}

function main(): void {
    const start: number = performance.now();

    const nodes: Node[] = [];
    for (let i = 0; i < 5000000; i++) {
        nodes.push(new Node(i, i * 1.5, "node_" + i));
    }

    for (let i = 0; i < 2000000; i++) {
        nodes.pop();
    }

    for (let i = 5000000; i < 7000000; i++) {
        nodes.push(new Node(i, i * 1.5, "node_" + i));
    }

    const end: number = performance.now();

    const elapsedMs: number = end - start;
    const elapsedS: number = elapsedMs / 1000.0;

    console.log(`  [Memory] Final Nodes: ${nodes.length} | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
}

main();

export {};
