using System;
using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Threading;

class Program
{
    const int PacketCount = 100000;
    const int PacketSize = 64;
    const int TotalBytes = PacketCount * PacketSize;

    static void Main()
    {
        using var listener = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        listener.Bind(new IPEndPoint(IPAddress.Loopback, 0));
        listener.Listen(1);

        var endPoint = (IPEndPoint)listener.LocalEndPoint!;
        long serverEndTime = 0;

        var serverThread = new Thread(() =>
        {
            using var serverSocket = listener.Accept();
            byte[] buffer = new byte[65536];
            int received = 0;
            while (received < TotalBytes)
            {
                int bytesRead = serverSocket.Receive(buffer, 0, Math.Min(buffer.Length, TotalBytes - received), SocketFlags.None);
                if (bytesRead <= 0)
                {
                    break;
                }
                received += bytesRead;
            }
            serverEndTime = Stopwatch.GetTimestamp();
        });
        serverThread.Start();

        using var client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        client.Connect(endPoint);

        byte[] packet = new byte[PacketSize];

        long start = Stopwatch.GetTimestamp();

        for (int i = 0; i < PacketCount; i++)
        {
            int sent = 0;
            while (sent < PacketSize)
            {
                sent += client.Send(packet, sent, PacketSize - sent, SocketFlags.None);
            }
        }

        serverThread.Join();

        TimeSpan elapsed = Stopwatch.GetElapsedTime(start, serverEndTime);
        double elapsedMs = elapsed.TotalMilliseconds;
        double elapsedS = elapsed.TotalSeconds;

        Console.WriteLine($"  [Network] Packets: 100000 | Size: 64 B | Time: {elapsedMs:F4} ms ({elapsedS:F6} s)");
    }
}
