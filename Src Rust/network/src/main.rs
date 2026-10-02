use std::io::{Read, Write};
use std::net::{Shutdown, TcpListener, TcpStream};
use std::sync::mpsc::channel;
use std::thread;
use std::time::Instant;

const NUM_PACKETS: usize = 100_000;
const PACKET_SIZE: usize = 64;
const TOTAL_BYTES: usize = NUM_PACKETS * PACKET_SIZE;
const CHUNK_SIZE: usize = 65_536;

#[inline(always)]
fn validate_packet(pkt: &[u8], expected: u32) {
    let seq = u32::from_le_bytes([pkt[0], pkt[1], pkt[2], pkt[3]]);
    if seq != expected {
        eprintln!(
            "Packet sequence mismatch: expected {}, got {}",
            expected, seq
        );
        std::process::exit(1);
    }
    let expected_byte = (expected & 0xFF) as u8;
    for &b in &pkt[4..PACKET_SIZE] {
        if b != expected_byte {
            eprintln!("Packet payload mismatch");
            std::process::exit(1);
        }
    }
}

fn main() {
    let mut send_buf = vec![0u8; TOTAL_BYTES];
    for i in 0..NUM_PACKETS {
        let offset = i * PACKET_SIZE;
        let seq = (i as u32).to_le_bytes();
        send_buf[offset..offset + 4].copy_from_slice(&seq);
        let val = (i & 0xFF) as u8;
        send_buf[offset + 4..offset + PACKET_SIZE].fill(val);
    }

    let (port_tx, port_rx) = channel();

    let server_handle = thread::spawn(move || {
        let listener = TcpListener::bind("127.0.0.1:0").expect("bind");
        let port = listener.local_addr().expect("local_addr").port();
        port_tx.send(port).expect("send port");

        let (mut client_stream, _) = listener.accept().expect("accept");
        client_stream.set_nodelay(true).expect("set_nodelay");

        let mut recv_buf = [0u8; CHUNK_SIZE];
        let mut packet_buf = [0u8; PACKET_SIZE];
        let mut packet_rem: usize = 0;
        let mut packets_received: u32 = 0;
        let mut total_received: usize = 0;
        let end_time: Instant;

        loop {
            let n = match client_stream.read(&mut recv_buf) {
                Ok(0) => break,
                Ok(bytes) => bytes,
                Err(e) => {
                    eprintln!("read error: {}", e);
                    std::process::exit(1);
                }
            };

            let mut offset = 0;
            let bytes_left = n;

            while offset < bytes_left {
                if packet_rem > 0 {
                    let needed = PACKET_SIZE - packet_rem;
                    let avail = bytes_left - offset;
                    let to_copy = avail.min(needed);
                    packet_buf[packet_rem..packet_rem + to_copy]
                        .copy_from_slice(&recv_buf[offset..offset + to_copy]);
                    packet_rem += to_copy;
                    offset += to_copy;

                    if packet_rem == PACKET_SIZE {
                        validate_packet(&packet_buf, packets_received);
                        packets_received += 1;
                        packet_rem = 0;
                    }
                } else if bytes_left - offset >= PACKET_SIZE {
                    validate_packet(&recv_buf[offset..offset + PACKET_SIZE], packets_received);
                    packets_received += 1;
                    offset += PACKET_SIZE;
                } else {
                    let to_copy = bytes_left - offset;
                    packet_buf[..to_copy].copy_from_slice(&recv_buf[offset..offset + to_copy]);
                    packet_rem = to_copy;
                    offset += to_copy;
                }
            }

            total_received += n;
            if total_received == TOTAL_BYTES {
                end_time = Instant::now();
                return end_time;
            }
        }

        Instant::now()
    });

    let port = port_rx.recv().expect("recv port");
    let addr = format!("127.0.0.1:{}", port);
    let mut client_stream = TcpStream::connect(addr).expect("connect");
    client_stream.set_nodelay(true).expect("set_nodelay");

    let start_time = Instant::now();

    let mut total_sent = 0;
    while total_sent < TOTAL_BYTES {
        let chunk = (TOTAL_BYTES - total_sent).min(CHUNK_SIZE);
        let n = client_stream
            .write(&send_buf[total_sent..total_sent + chunk])
            .expect("write");
        if n == 0 {
            break;
        }
        total_sent += n;
    }

    client_stream.shutdown(Shutdown::Write).expect("shutdown");
    let end_time = server_handle.join().expect("server join");

    let duration = end_time.duration_since(start_time);
    let elapsed_ms = duration.as_secs_f64() * 1000.0;
    let elapsed_s = duration.as_secs_f64();

    println!(
        "  [Network] Packets: {} | Size: {} B | Time: {:.4} ms ({:.6} s)",
        NUM_PACKETS, PACKET_SIZE, elapsed_ms, elapsed_s
    );
}
