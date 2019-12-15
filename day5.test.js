const { getInput, takeLast, take } = require("./utils");

function getValue(mode, value, instructions) {
  switch (mode) {
    case 1: {
      return value;
    }
    case 0:
    default: {
      return instructions[value];
    }
  }
}

function diagnostic(instructions) {
  return input => {
    let result;
    for (let pointer = 0; pointer < instructions.length; pointer++) {
      const instruction = instructions[pointer];
      const opcode = instruction % 100;
      const modeC = Math.floor((instruction / 100) % 10);
      const modeB = Math.floor((instruction / 1000) % 10);
      const modeA = Math.floor((instruction / 10000) % 10);

      debugger;

      let value;
      let address;

      switch (opcode) {
        case 1: {
          const parameters = take(3)(instructions.slice(pointer + 1));
          const value1 = getValue(modeC, parameters[0], instructions);
          const value2 = getValue(modeB, parameters[1], instructions);
          value = value1 + value2;
          address = getValue(modeA, parameters[2], instructions);
          pointer = pointer + 3;
          break;
        }
        case 2: {
          const parameters = take(3)(instructions.slice(pointer + 1));
          const value1 = getValue(modeC, parameters[0], instructions);
          const value2 = getValue(modeB, parameters[1], instructions);
          value = value1 * value2;
          address = getValue(modeA, parameters[2], instructions);
          pointer = pointer + 3;
          break;
        }
        case 3: {
          const parameters = take(1)(instructions.slice(pointer + 1));
          address = parameters[0];
          pointer = pointer + 1;
          break;
        }
        case 4: {
          const parameters = take(1)(instructions.slice(pointer + 1));
          address = getValue(modeC, parameters[0], instructions);
          result = instructions[address];
          pointer = pointer + 1;
          console.log("result: ", result);
          break;
        }
        case 99: {
          console.log('instructions: ', instructions);
          return `Diagnostic code: ${result}`;
        }
        default:
        // return "Operation failed";
      }

      instructions[address] = value;
    }
  };
}

console.log(
  "diagnostic: ",
  diagnostic(getInput("day5.txt", ",").map(Number))(1)
);
