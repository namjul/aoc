import { getInput } from "./utils";

type Opcode1 = {
  type: 1;
  operation: (value1: number, value2: number) => number;
};
type Opcode2 = {
  type: 2;
  operation: (value1: number, value2: number) => number;
};
type IntcodeEnd = { type: 99; operation: () => null };
type IntcodeError = { type: 0; operation: () => null };
type Either = Opcode1 | Opcode2 | IntcodeEnd | IntcodeError;

function sum(value1: number, value2: number) {
  return value1 + value2;
}

function multiply(value1: number, value2: number) {
  return value1 * value2;
}

function getOpcodeType(code: number): Either {
  switch (code) {
    case 1: {
      return { type: 1, operation: sum };
    }
    case 2: {
      return { type: 2, operation: multiply };
    }
    case 99: {
      return { type: 99, operation: () => null };
    }
    default: {
      return { type: 0, operation: () => null };
    }
  }
}

function calcIntCode(input: Array<string>) {
  const result = [...input.map(Number)];

  for (let i = 0, len = result.length; i < len; i++) {
    const opcodeGroup = i % 4 === 0;
    if (opcodeGroup) {
      const [opcode, position1, position2, outputPosition] = result.slice(
        i,
        i + 4
      );

      const value1 = result[position1];
      const value2 = result[position2];
      const opcodeType = getOpcodeType(opcode);
      const value = opcodeType.operation(value1, value2);

      if (opcodeType.type === 99) {
        break;
      }

      if (value !== null) {
        result[outputPosition] = value;
      }
    }
  }

  return result;
}

function calcValue(noun: string, verb: string) {
  return (input: Array<string>) => {
    input[1] = noun;
    input[2] = verb;
    return calcIntCode(input)[0];
  };
}

function calcFrom(from: number) {
  return (input: Array<string>) => {
    for (let i = 0, len = 100; i < len; i++) {
      for (let j = 0, len = 100; j < len; j++) {
        const value = calcValue(String(i), String(j))(input);
        if(value === from) {
          return 100 * i + j
        }
      }
    }
  };
}

describe("Day 2: 1202 Program Alarm", () => {
  const input = getInput("day2.txt", ",");
  test("part1", () => {
    expect(calcIntCode(["1", "0", "0", "0", "99"])).toEqual([2, 0, 0, 0, 99]);
    expect(calcIntCode(["2", "3", "0", "3", "99"])).toEqual([2, 3, 0, 6, 99]);
    expect(calcIntCode(["2", "4", "4", "5", "99", "0"])).toEqual([
      2,
      4,
      4,
      5,
      99,
      9801
    ]);
    console.log(calcValue("12", "2")(input));
  });
  test("part2", () => {
    console.log(calcFrom(19690720)(input) );
  });
});
