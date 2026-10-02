import java.util.HashMap;
import java.util.Map;

public class Main {
    static Map<String, Object> parseJson(String s) {
        Map<String, Object> map = new HashMap<>();
        String trimmed = s.trim();
        if (trimmed.startsWith("{") && trimmed.endsWith("}")) {
            trimmed = trimmed.substring(1, trimmed.length() - 1).trim();
            String[] pairs = trimmed.split(",");
            for (String pair : pairs) {
                String[] kv = pair.split(":", 2);
                String k = kv[0].trim();
                String v = kv[1].trim();
                if (k.startsWith("\"") && k.endsWith("\"")) {
                    k = k.substring(1, k.length() - 1);
                }
                if (v.startsWith("\"") && v.endsWith("\"")) {
                    map.put(k, v.substring(1, v.length() - 1));
                } else {
                    map.put(k, Long.parseLong(v));
                }
            }
        }
        return map;
    }

    public static void main(String[] args) {
        Map<String, Object> data = parseJson("{\"name\":\"Speedtest\",\"version\":1}");
        System.out.println(data.get("name"));
    }
}
