using System;
using System.Collections.Generic;
using System.Diagnostics;

class Node
{
    public int ID { get; set; }
    public double Value { get; set; }
    public string Name { get; set; }

    public Node(int id, double value, string name)
    {
        ID = id;
        Value = value;
        Name = name;
    }
}

class Program
{
    static void Main()
    {
        long start = Stopwatch.GetTimestamp();

        List<Node> nodes = new List<Node>(5_000_000);
        for (int i = 0; i < 5_000_000; i++)
        {
            nodes.Add(new Node(i, (double)i, "Node"));
        }

        nodes.RemoveRange(3_000_000, 2_000_000);

        for (int i = 0; i < 2_000_000; i++)
        {
            nodes.Add(new Node(5_000_000 + i, (double)(5_000_000 + i), "Node"));
        }

        TimeSpan elapsed = Stopwatch.GetElapsedTime(start);

        int finalCount = nodes.Count;
        if (finalCount != 5_000_000 || nodes[4_999_999].ID != 6_999_999)
        {
            throw new InvalidOperationException("ERROR: Expected 5000000 nodes");
        }

        double elapsedMs = elapsed.TotalMilliseconds;
        double elapsedS = elapsed.TotalSeconds;

        Console.WriteLine($"  [Memory] Final Nodes: {finalCount} | Time: {elapsedMs,10:F4} ms ({elapsedS,8:F6} s)");
    }
}
