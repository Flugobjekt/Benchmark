using System;
using System.Text.Json;

class Program
{
    static void Main()
    {
        string json = "{\"name\":\"Speedtest\",\"version\":1}";
        using var doc = JsonDocument.Parse(json);
        string name = doc.RootElement.GetProperty("name").GetString()!;
        Console.WriteLine(name);
    }
}
