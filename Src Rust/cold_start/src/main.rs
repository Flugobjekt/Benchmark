#[allow(dead_code)]
struct Config {
    name: String,
    version: i32,
}

fn parse_json(s: &str) -> Option<Config> {
    let s = s.trim();
    if !s.starts_with('{') || !s.ends_with('}') {
        return None;
    }
    let inner = &s[1..s.len() - 1];
    let mut name = None;
    let mut version = None;
    for part in inner.split(',') {
        let mut kv = part.splitn(2, ':');
        let key = kv.next()?.trim().trim_matches('"');
        let val = kv.next()?.trim();
        if key == "name" {
            name = Some(val.trim_matches('"').to_string());
        } else if key == "version" {
            version = val.parse::<i32>().ok();
        }
    }
    Some(Config {
        name: name?,
        version: version?,
    })
}

fn main() {
    let json_str = r#"{"name":"Speedtest","version":1}"#;
    if let Some(config) = parse_json(json_str) {
        println!("{}", config.name);
    }
}
