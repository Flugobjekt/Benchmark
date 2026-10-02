local json = '{"name":"Speedtest","version":1}'
local name = json:match('"name"%s*:%s*"([^"]+)"')
print(name)
