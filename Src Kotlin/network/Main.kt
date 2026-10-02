import java.net.InetAddress
import java.net.ServerSocket
import java.net.Socket
import java.util.Locale
import java.util.concurrent.atomic.AtomicLong
import kotlin.concurrent.thread

fun main() {
    val serverSocket = ServerSocket(0, 1, InetAddress.getByName("127.0.0.1"))
    val port = serverSocket.localPort
    val serverEndTime = AtomicLong(0)

    val serverThread = thread {
        val clientSocket = serverSocket.accept()
        val input = clientSocket.getInputStream()
        val buffer = ByteArray(64)
        var totalBytes = 0
        val expectedBytes = 100_000 * 64
        while (totalBytes < expectedBytes) {
            val bytesRead = input.read(buffer, 0, Math.min(buffer.size, expectedBytes - totalBytes))
            if (bytesRead < 0) {
                break
            }
            totalBytes += bytesRead
        }
        serverEndTime.set(System.nanoTime())
        clientSocket.close()
        serverSocket.close()
    }

    val clientSocket = Socket("127.0.0.1", port)
    val output = clientSocket.getOutputStream()
    val packet = ByteArray(64)

    val start = System.nanoTime()
    for (i in 0 until 100_000) {
        output.write(packet)
    }
    output.flush()

    serverThread.join()
    clientSocket.close()

    val end = serverEndTime.get()
    val elapsedMs = (end - start) / 1_000_000.0
    val elapsedS = elapsedMs / 1000.0

    System.out.printf(
        Locale.US,
        "  [Network] Packets: 100000 | Size: 64 B | Time: %.4f ms (%.6f s)%n",
        elapsedMs, elapsedS
    )
}
