class Node {
    constructor(id, value, name) {
        this.id = id;
        this.value = value;
        this.name = name;
    }
}

function main() {
    const start = performance.now();

    const nodes = [];
    for (let i = 0; i < 5000000; i++) {
        nodes.push(new Node(i, i * 1.5, "node_" + i));
    }

    for (let i = 0; i < 2000000; i++) {
        nodes.pop();
    }

    for (let i = 5000000; i < 7000000; i++) {
        nodes.push(new Node(i, i * 1.5, "node_" + i));
    }

    const end = performance.now();

    const elapsedMs = end - start;
    const elapsedS = elapsedMs / 1000.0;

    console.log(`  [Memory] Final Nodes: ${nodes.length} | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
}

main();
