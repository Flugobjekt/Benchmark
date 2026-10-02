import Foundation

let jsonString = "{\"name\":\"Speedtest\",\"version\":1}"
if let data = jsonString.data(using: .utf8),
   let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
   let name = obj["name"] as? String {
    print(name)
}
