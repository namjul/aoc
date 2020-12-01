const isIncreasing = (input: Array<number>): boolean =>
  input.every((number, index, array) =>
    index === 0 ? true : array[index - 1] <= number
  );

const hasAdjacentDigits = (input: Array<number>): boolean =>
  input.some((number, index, array) =>
    index === 0 ? false : array[index - 1] === number
  );

const hasDoubleAdjacentDigits = (input: Array<number>) => {
  const result = input.reduce((accumulator, number) => {
    if (!accumulator[number]) {
      accumulator[number] = [];
    }
    accumulator[number].push(number);
    return accumulator;
  }, {});

  return Object.values(result).some((list: Array<number>) => list.length === 2);
};

function calculatePassword(input: Array<number>) {
  const result = [];
  for (var i = input[0], len = input[1]; i < len; i++) {
    const numberList = String(i)
      .split("")
      .map(Number);
    if (numberList.length === 6) {
      if (isIncreasing(numberList)) {
        if (hasDoubleAdjacentDigits(numberList)) {
          result.push(numberList.join(""));
        }
      }
    }
  }
  return result;
}

describe("Day 1: The Tyranny of the Rocket Equation", () => {
  test("isIncreasing", () => {
    expect(isIncreasing([1, 2, 3, 4, 5, 6])).toBeTruthy();
    expect(isIncreasing([1, 2, 3, 3, 5, 6])).toBeTruthy();
    expect(isIncreasing([1, 2, 3, 2, 5, 6])).toBeFalsy();
  });
  test("hasAdjacentDigits", () => {
    expect(hasAdjacentDigits([1, 2, 3, 4, 5, 6])).toBeFalsy();
    expect(hasAdjacentDigits([1, 2, 3, 3, 5, 6])).toBeTruthy();
    expect(hasAdjacentDigits([1, 2, 3, 2, 5, 6])).toBeFalsy();
  });
  test("hasDoubleAdjacentDigits", () => {
    expect(hasDoubleAdjacentDigits([1, 4, 4, 4, 5, 6])).toBeFalsy();
    expect(hasDoubleAdjacentDigits([1, 2, 3, 3, 5, 6])).toBeTruthy();
    expect(hasDoubleAdjacentDigits([1, 2, 3, 3, 3, 3])).toBeFalsy();
  });
  test("part1", () => {
    const input = [165432, 707912];
    console.log(
      "calculatePassword([165432, 707912]): ",
      calculatePassword(input).length
    );
  });
  /* test("part2", () => {
  }); */
});
