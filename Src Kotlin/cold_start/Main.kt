fun main() {
    val json = """{"name":"Speedtest","version":1}"""
    val match = Regex(""""name"\s*:\s*"([^"]+)"""").find(json)
    if (match != null) {
        println(match.groupValues[1])
    }
}
