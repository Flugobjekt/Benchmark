#include <iostream>
#include <string_view>

int main() {
    std::string_view json = "{\"name\":\"Speedtest\",\"version\":1}";
    std::string_view key = "\"name\":\"";
    auto start_pos = json.find(key);
    if (start_pos != std::string_view::npos) {
        start_pos += key.length();
        auto end_pos = json.find('"', start_pos);
        if (end_pos != std::string_view::npos) {
            std::cout << json.substr(start_pos, end_pos - start_pos) << "\n";
        }
    }
    return 0;
}
