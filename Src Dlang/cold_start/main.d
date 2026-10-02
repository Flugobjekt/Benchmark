import std.json : parseJSON;
import std.stdio : writeln;

void main() {
    string json = `{"name":"Speedtest","version":1}`;
    auto parsed = parseJSON(json);
    writeln(parsed["name"].str);
}
