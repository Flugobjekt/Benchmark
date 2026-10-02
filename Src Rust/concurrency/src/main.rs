use std::thread;
use std::time::{Duration, Instant};

fn main() {
    let start = Instant::now();
    let mut handles = Vec::with_capacity(500);
    for _ in 0..500 {
        handles.push(thread::spawn(|| {
            thread::sleep(Duration::from_millis(200));
        }));
    }
    for h in handles {
        h.join().unwrap();
    }
    let duration = start.elapsed();
    let elapsed_ms = duration.as_secs_f64() * 1000.0;
    let elapsed_s = duration.as_secs_f64();

    println!(
        "  [Concurrency] Tasks: 500 | Delay: 200 ms | Time: {:.4} ms ({:.6} s)",
        elapsed_ms, elapsed_s
    );
}
