using System;
using System.Diagnostics;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main()
    {
        string dir = "./tmp_io_test";
        if (Directory.Exists(dir))
        {
            Directory.Delete(dir, true);
        }
        Directory.CreateDirectory(dir);

        Parallel.For(0, 10000, i =>
        {
            string path = Path.Combine(dir, $"file_{i}.txt");
            string content = (i % 10 == 0)
                ? "Alpha line\nBenchmark line\nOmega line\n"
                : "Alpha line\nNormal line\nOmega line\n";
            File.WriteAllText(path, content);
        });

        long matches = 0;
        long start = Stopwatch.GetTimestamp();

        Parallel.For(0, 10000, i =>
        {
            string path = Path.Combine(dir, $"file_{i}.txt");
            string text = File.ReadAllText(path);
            if (text.Contains("Benchmark"))
            {
                Interlocked.Increment(ref matches);
            }
        });

        TimeSpan elapsed = Stopwatch.GetElapsedTime(start);

        if (Directory.Exists(dir))
        {
            Directory.Delete(dir, true);
        }

        double elapsedMs = elapsed.TotalMilliseconds;
        double elapsedS = elapsed.TotalSeconds;

        Console.WriteLine($"  [IO-Bound] Files: 10000 | Matches: {matches,4} | Time: {elapsedMs,10:F4} ms ({elapsedS,8:F6} s)");

        if (matches != 1000)
        {
            throw new InvalidOperationException($"ERROR: Expected 1000 matches, got {matches}");
        }
    }
}
