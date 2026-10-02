import net from "node:net";

async function main() {
    const totalPackets = 100000;
    const packetSize = 64;
    const totalBytes = totalPackets * packetSize;
    const packet = Buffer.alloc(packetSize);

    const server = net.createServer((socket) => {
        let receivedBytes = 0;
        socket.on("data", (chunk) => {
            receivedBytes += chunk.length;
            if (receivedBytes >= totalBytes) {
                socket.write(Buffer.from([1]));
                socket.end();
            }
        });
    });

    await new Promise((resolve) => {
        server.listen(0, "127.0.0.1", () => {
            const port = server.address().port;
            const client = net.createConnection({ host: "127.0.0.1", port }, () => {
                const start = performance.now();

                for (let i = 0; i < totalPackets; i++) {
                    client.write(packet);
                }

                client.on("data", () => {
                    client.end();
                });

                client.on("close", () => {
                    const end = performance.now();
                    const elapsedMs = end - start;
                    const elapsedS = elapsedMs / 1000.0;
                    console.log(`  [Network] Packets: ${totalPackets} | Size: ${packetSize} B | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
                    server.close(() => resolve());
                });
            });
        });
    });
}

main();
