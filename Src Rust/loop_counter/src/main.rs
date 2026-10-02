use std::hint::black_box;
use std::time::Instant;

fn run_counter(limit: u64) {
    let start = Instant::now();

    let mut count: u64 = 0;
    for _ in 1..=limit {
        count += 1;
        black_box(&mut count);
    }

    let duration = start.elapsed();
    let elapsed_ms = duration.as_secs_f64() * 1_000.0;
    let elapsed_s = duration.as_secs_f64();

    println!(
        "  [Counter] Limit: {:>11} | Count:  {:>9} | Time: {:>10.4} ms ({:>8.6} s)",
        limit, count, elapsed_ms, elapsed_s
    );

    assert_eq!(count, limit);
}

fn main() {
    println!("-- Loop Counter --");
    run_counter(1_000_000);
    run_counter(10_000_000);
    run_counter(100_000_000);
    run_counter(1_000_000_000);
}
