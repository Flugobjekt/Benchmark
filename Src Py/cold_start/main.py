import json


def main() -> None:
    data = json.loads('{"name":"Speedtest","version":1}')
    print(data["name"])


if __name__ == "__main__":
    main()
