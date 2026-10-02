use std::fs;
use std::io::Write;
use std::time::Instant;

fn main() {
    let dir_path = "./tmp_io_test";
    let _ = fs::remove_dir_all(dir_path);
    fs::create_dir(dir_path).unwrap();

    let content_match = "First line\nBenchmark\nThird line\n";
    let content_nomatch = "First line\nSecond line\nThird line\n";

    for i in 0..10_000 {
        let file_path = format!("{}/file_{}.txt", dir_path, i);
        let mut file = fs::File::create(&file_path).unwrap();
        if i % 10 == 0 {
            file.write_all(content_match.as_bytes()).unwrap();
        } else {
            file.write_all(content_nomatch.as_bytes()).unwrap();
        }
    }

    let start = Instant::now();
    let mut matches = 0;
    for i in 0..10_000 {
        let file_path = format!("{}/file_{}.txt", dir_path, i);
        let content = fs::read(file_path).unwrap();
        if content.windows(9).any(|w| w == b"Benchmark") {
            matches += 1;
        }
    }
    let duration = start.elapsed();

    let elapsed_ms = duration.as_secs_f64() * 1000.0;
    let elapsed_s = duration.as_secs_f64();

    println!(
        "  [IO-Bound] Files: 10000 | Matches: {} | Time: {:.4} ms ({:.6} s)",
        matches, elapsed_ms, elapsed_s
    );

    fs::remove_dir_all(dir_path).unwrap();
}
