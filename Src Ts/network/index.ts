import net from "node:net";

async function main(): Promise<void> {
    const totalPackets: number = 100000;
    const packetSize: number = 64;
    const totalBytes: number = totalPackets * packetSize;
    const packet: Uint8Array = new Uint8Array(packetSize);

    const server: net.Server = net.createServer((socket: net.Socket) => {
        let receivedBytes: number = 0;
        socket.on("data", (chunk: Buffer) => {
            receivedBytes += chunk.length;
            if (receivedBytes >= totalBytes) {
                socket.write(new Uint8Array([1]));
                socket.end();
            }
        });
    });

    await new Promise<void>((resolve) => {
        server.listen(0, "127.0.0.1", () => {
            const address = server.address() as net.AddressInfo;
            const port: number = address.port;
            const client: net.Socket = net.createConnection({ host: "127.0.0.1", port }, () => {
                const start: number = performance.now();

                for (let i = 0; i < totalPackets; i++) {
                    client.write(packet);
                }

                client.on("data", () => {
                    client.end();
                });

                client.on("close", () => {
                    const end: number = performance.now();
                    const elapsedMs: number = end - start;
                    const elapsedS: number = elapsedMs / 1000.0;
                    console.log(`  [Network] Packets: ${totalPackets} | Size: ${packetSize} B | Time: ${elapsedMs.toFixed(4)} ms (${elapsedS.toFixed(6)} s)`);
                    server.close(() => resolve());
                });
            });
        });
    });
}

main();

export {};
