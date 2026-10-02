declare const Bun: {
    write(destination: string, data: string): Promise<number>;
    file(path: string): { text(): Promise<string> };
};

declare module "node:fs/promises" {
    export function mkdir(path: string, options?: { recursive?: boolean }): Promise<string | undefined>;
    export function rm(path: string, options?: { recursive?: boolean; force?: boolean }): Promise<void>;
}
