#include <iostream>
#include <vector>
#include <string>
#include <chrono>
#include <iomanip>

struct Node {
    int id;
    double value;
    std::string text;
};

int main() {
    auto start = std::chrono::steady_clock::now();

    std::vector<Node*> nodes;
    nodes.resize(5000000);

    for (int i = 0; i < 5000000; ++i) {
        nodes[i] = new Node{i, static_cast<double>(i), "node_" + std::to_string(i)};
    }

    for (int i = 3000000; i < 5000000; ++i) {
        delete nodes[i];
    }

    for (int i = 3000000; i < 5000000; ++i) {
        nodes[i] = new Node{i, static_cast<double>(i), "new_" + std::to_string(i)};
    }

    auto end = std::chrono::steady_clock::now();

    std::chrono::duration<double, std::milli> elapsed_ms = end - start;
    std::chrono::duration<double> elapsed_s = end - start;

    std::cout << "  [Memory] Final Nodes: 5000000 | Time: "
              << std::fixed << std::setprecision(4) << elapsed_ms.count() << " ms ("
              << std::setprecision(6) << elapsed_s.count() << " s)\n";

    for (int i = 0; i < 5000000; ++i) {
        delete nodes[i];
    }

    return 0;
}
