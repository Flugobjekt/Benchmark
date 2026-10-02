use std::hint::black_box;
use std::time::Instant;

fn run_sieve(limit: usize, expected: usize) {
    let num_odds = limit / 2;
    let mut is_prime = vec![true; num_odds].into_boxed_slice();
    if num_odds > 0 {
        is_prime[0] = false;
    }

    let ptr = is_prime.as_mut_ptr();

    let start = Instant::now();

    let mut i = 1;
    while (2 * i + 1) * (2 * i + 1) < limit {
        let is_p = unsafe { *ptr.add(i) };
        if is_p {
            let p = 2 * i + 1;
            let mut j = 2 * i * (i + 1);
            let p4 = 4 * p;

            while j + p4 <= num_odds {
                unsafe {
                    *ptr.add(j) = false;
                    *ptr.add(j + p) = false;
                    *ptr.add(j + 2 * p) = false;
                    *ptr.add(j + 3 * p) = false;
                }
                j += p4;
            }

            while j < num_odds {
                unsafe {
                    *ptr.add(j) = false;
                }
                j += p;
            }
        }
        i += 1;
    }

    let duration = start.elapsed();
    black_box(&is_prime);

    let prime_count = 1 + is_prime.iter().filter(|&&p| p).count();

    let elapsed_ms = duration.as_secs_f64() * 1_000.0;
    let elapsed_s = duration.as_secs_f64();

    println!(
        "  [Sieve]   Limit: {:>11} | Primes: {:>9} | Time: {:>10.4} ms ({:>8.6} s)",
        limit, prime_count, elapsed_ms, elapsed_s
    );

    assert_eq!(prime_count, expected);
}

fn main() {
    println!("-- Prime Sieve --");
    run_sieve(1_000_000, 78_498);
    run_sieve(10_000_000, 664_579);
    run_sieve(100_000_000, 5_761_455);
    run_sieve(1_000_000_000, 50_847_534);
}
