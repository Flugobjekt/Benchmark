import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicLong;

public class Main {
    static final int PACKET_COUNT = 100_000;
    static final int PACKET_SIZE = 64;
    static final int TOTAL_BYTES = PACKET_COUNT * PACKET_SIZE;

    public static void main(String[] args) throws Exception {
        ServerSocket serverSocket = new ServerSocket(0, 1, InetAddress.getByName("127.0.0.1"));
        int port = serverSocket.getLocalPort();
        AtomicLong serverEndTime = new AtomicLong(0);

        Thread serverThread = new Thread(() -> {
            try (Socket socket = serverSocket.accept();
                 InputStream in = socket.getInputStream()) {
                byte[] buffer = new byte[65536];
                int received = 0;
                while (received < TOTAL_BYTES) {
                    int read = in.read(buffer, 0, Math.min(buffer.length, TOTAL_BYTES - received));
                    if (read < 0) {
                        break;
                    }
                    received += read;
                }
                serverEndTime.set(System.nanoTime());
            } catch (Exception e) {
                throw new RuntimeException(e);
            } finally {
                try {
                    serverSocket.close();
                } catch (Exception ignored) {
                }
            }
        });
        serverThread.start();

        Socket clientSocket = new Socket("127.0.0.1", port);
        OutputStream out = clientSocket.getOutputStream();

        byte[] packet = new byte[PACKET_SIZE];

        long start = System.nanoTime();

        for (int i = 0; i < PACKET_COUNT; i++) {
            out.write(packet);
        }
        out.flush();

        serverThread.join();

        long end = serverEndTime.get();

        clientSocket.close();

        double elapsedMs = (end - start) / 1_000_000.0;
        double elapsedS = elapsedMs / 1000.0;

        System.out.printf(
                Locale.US,
                "  [Network] Packets: 100000 | Size: 64 B | Time: %.4f ms (%.6f s)%n",
                elapsedMs, elapsedS);
    }
}
