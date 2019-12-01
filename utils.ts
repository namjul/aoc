import * as fs from "fs";

function getInput(path: string): Array<string> {
  return fs
    .readFileSync(`./inputs/${path}`)
    .toString()
    .split("\n")
    .slice(0, -1);
}

export { getInput };
