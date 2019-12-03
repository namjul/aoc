import * as fs from "fs";

function getInput(path: string, separator: string): Array<string> {
  return fs
    .readFileSync(`./inputs/${path}`)
    .toString()
    .split(separator)
    .slice(0, -1);
}

export { getInput };
