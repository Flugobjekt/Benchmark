use std::time::Instant;

#[allow(dead_code)]
struct Node {
    id: i32,
    value: f64,
    name: String,
}

fn main() {
    let start = Instant::now();
    let mut nodes: Vec<Node> = Vec::with_capacity(5_000_000);
    for i in 0..5_000_000 {
        nodes.push(Node {
            id: i,
            value: i as f64,
            name: String::from("Speedtest"),
        });
    }

    nodes.truncate(3_000_000);

    for i in 3_000_000..5_000_000 {
        nodes.push(Node {
            id: i,
            value: i as f64,
            name: String::from("Speedtest"),
        });
    }

    let duration = start.elapsed();
    let elapsed_ms = duration.as_secs_f64() * 1000.0;
    let elapsed_s = duration.as_secs_f64();

    println!(
        "  [Memory] Final Nodes: {} | Time: {:.4} ms ({:.6} s)",
        nodes.len(),
        elapsed_ms,
        elapsed_s
    );
}
