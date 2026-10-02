using System;
using System.Diagnostics;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        long start = Stopwatch.GetTimestamp();

        Task[] tasks = new Task[500];
        for (int i = 0; i < 500; i++)
        {
            tasks[i] = Task.Delay(200);
        }

        await Task.WhenAll(tasks);

        TimeSpan elapsed = Stopwatch.GetElapsedTime(start);
        double elapsedMs = elapsed.TotalMilliseconds;
        double elapsedS = elapsed.TotalSeconds;

        Console.WriteLine($"  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: {elapsedMs,10:F4} ms ({elapsedS,8:F6} s)");
    }
}
