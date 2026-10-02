using System;
using System.Diagnostics;

class Program
{
    static unsafe void RunSieve(int limit, int expected)
    {
        int numOdds = limit / 2;
        byte[] isPrime = new byte[numOdds];
        Array.Fill(isPrime, (byte)1);
        if (numOdds > 0)
        {
            isPrime[0] = 0;
        }

        fixed (byte* ptr = isPrime)
        {
            long start = Stopwatch.GetTimestamp();

            for (int i = 1; (2 * i + 1) * (2 * i + 1) < limit; i++)
            {
                if (ptr[i] != 0)
                {
                    int p = 2 * i + 1;
                    int j = 2 * i * (i + 1);
                    int p4 = 4 * p;

                    while (j + p4 <= numOdds)
                    {
                        ptr[j] = 0;
                        ptr[j + p] = 0;
                        ptr[j + 2 * p] = 0;
                        ptr[j + 3 * p] = 0;
                        j += p4;
                    }

                    while (j < numOdds)
                    {
                        ptr[j] = 0;
                        j += p;
                    }
                }
            }

            TimeSpan elapsed = Stopwatch.GetElapsedTime(start);

            int count = 1;
            for (int i = 1; i < numOdds; i++)
            {
                count += ptr[i];
            }

            double elapsedMs = elapsed.TotalMilliseconds;
            double elapsedS = elapsed.TotalSeconds;

            Console.WriteLine($"  [Sieve]   Limit: {limit,11} | Primes: {count,9} | Time: {elapsedMs,10:F4} ms ({elapsedS,8:F6} s)");

            if (count != expected)
            {
                throw new InvalidOperationException($"ERROR: Expected {expected}, got {count}");
            }
        }
    }

    static void Main()
    {
        RunSieve(1_000_000, 78_498);
        RunSieve(10_000_000, 664_579);
        RunSieve(100_000_000, 5_761_455);
        RunSieve(1_000_000_000, 50_847_534);
    }
}
