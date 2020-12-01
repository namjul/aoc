import { getInput } from "./utils";

function calculateFuel(value: number) {
  return Math.floor(value / 3) - 2;
}

function sum(value1: number, value2: number) {
  return value1 + value2;
}

function calculateRequiredFuelPart1(input: Array<string>) {
  return input
    .map(Number)
    .map(calculateFuel)
    .reduce(sum, 0);
}

function calculateRequiredFuelPart2(input: Array<string>) {
  function recursion(value: number): number {
    const result = calculateFuel(value);
    if (result > 0) {
      return result + recursion(result);
    }
    return 0;
  }
  return input
    .map(Number)
    .map(recursion)
    .reduce(sum, 0);
}

describe("Day 1: The Tyranny of the Rocket Equation", () => {
  test("part1", () => {
    expect(calculateRequiredFuelPart1(["12"])).toEqual(2);
    expect(calculateRequiredFuelPart1(["14"])).toEqual(2);
    expect(calculateRequiredFuelPart1(["1969"])).toEqual(654);
    expect(calculateRequiredFuelPart1(["100756"])).toEqual(33583);
    console.log(calculateRequiredFuelPart1(getInput("day1.txt", "\n")));
  });
  test("part2", () => {
    expect(calculateRequiredFuelPart2(["14"])).toEqual(2);
    expect(calculateRequiredFuelPart2(["1969"])).toEqual(966);
    expect(calculateRequiredFuelPart2(["100756"])).toEqual(50346);
    console.log(calculateRequiredFuelPart2(getInput("day1.txt", "\n")));
  });
});
