interface Data {
    name: string;
    version: number;
}

const data: Data = JSON.parse('{"name":"Speedtest","version":1}');
console.log(data.name);

export {};
