import core.thread.osthread : Thread;
import core.time : MonoTime, Duration;
import std.socket : TcpSocket, InternetAddress, SocketOptionLevel, SocketOption;
import std.stdio : writefln;

void main() {
    auto server = new TcpSocket();
    server.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
    server.bind(new InternetAddress("127.0.0.1", 0));
    server.listen(1);

    auto localAddr = cast(InternetAddress) server.localAddress;
    ushort port = localAddr.port;

    MonoTime serverEndTime;

    auto serverThread = new Thread({
        auto client = server.accept();
        ubyte[64] buffer;
        size_t totalBytes = 0;
        enum size_t expectedBytes = 100_000 * 64;
        while (totalBytes < expectedBytes) {
            auto received = client.receive(buffer[]);
            if (received <= 0) {
                break;
            }
            totalBytes += received;
        }
        serverEndTime = MonoTime.currTime;
        client.close();
        server.close();
    });
    serverThread.start();

    auto client = new TcpSocket();
    client.connect(new InternetAddress("127.0.0.1", port));

    MonoTime start = MonoTime.currTime;

    ubyte[64] packet;
    for (size_t i = 0; i < 100_000; ++i) {
        size_t sent = 0;
        while (sent < 64) {
            auto n = client.send(packet[sent .. $]);
            if (n <= 0) {
                break;
            }
            sent += n;
        }
    }

    serverThread.join();
    client.close();

    Duration elapsed = serverEndTime - start;
    double elapsedMs = cast(double) elapsed.total!"nsecs" / 1_000_000.0;
    double elapsedS = cast(double) elapsed.total!"nsecs" / 1_000_000_000.0;

    writefln("  [Network] Packets: 100000 | Size: 64 B | Time: %.4f ms (%.6f s)",
             elapsedMs, elapsedS);
}
