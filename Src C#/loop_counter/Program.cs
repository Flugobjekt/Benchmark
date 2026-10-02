using System;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Threading;

class Program
{
    static long sink;

    [MethodImpl(MethodImplOptions.NoInlining)]
    static void RunCounter(long limit)
    {
        long start = Stopwatch.GetTimestamp();

        long count = 0;
        for (long i = 1; i <= limit; i++)
        {
            count++;
        }

        TimeSpan elapsed = Stopwatch.GetElapsedTime(start);
        Volatile.Write(ref sink, count);

        double elapsedMs = elapsed.TotalMilliseconds;
        double elapsedS = elapsed.TotalSeconds;

        Console.WriteLine($"  [Counter] Limit: {limit,11} | Count:  {count,9} | Time: {elapsedMs,10:F4} ms ({elapsedS,8:F6} s)");

        if (count != limit)
        {
            throw new InvalidOperationException($"ERROR: Expected {limit}, got {count}");
        }
    }

    static void Main()
    {
        RunCounter(1_000_000);
        RunCounter(10_000_000);
        RunCounter(100_000_000);
        RunCounter(1_000_000_000);
    }
}
