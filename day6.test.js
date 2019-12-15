const { getInput } = require("./utils");
/* 
[
  'COM': [
    ['B', [
      ['C', [
        ['D', [
          ['I', []],
          ['E', [
            ['F', []],
            ['J', [
              ['K', [
                ['L', []]
              ]]
            ]]
          ]]
        ]]
      ]],
      ['G', [
        ['H', []]
      ]],
    ]]
  ]
]

var graph = {
    COM: ['B'],
    B: ['C', 'G'],
    C: ['D'],
    G: ['H'],
    H: [],
    D: ['I', 'E'],
    I: [],
    E: ['F', 'J'],
    F: [],
    J: ['K'],
    K: ['L'],
    L: [],
};

{
  H: 'G',
  G: 'B',
  B: 'COM',
  COM: null,
  C: 'B',
  D: 'C',
  I: 'D',
  E: 'D',
  F: 'E',
  J: 'E',
  K: 'J',
  L: 'K',
}
 */

function getMapping(input) {
  return input.reduce((accumulator, current) => {
    // child is orbiting parent
    const [parent, child] = current.split(")");
    return {
      ...accumulator,
      [child]: parent
    };
  }, {});
}

function calculateOrbits(input) {
  const mapping = getMapping(input);
  return Object.keys(mapping).reduce(function visit(accumulator, current) {
    const parent = mapping[current];
    if (parent) {
      return visit(accumulator + 1, parent);
    }
    return accumulator;
  }, 0);
}

function calculateMinimumOrbitTransfers(input) {
  const mapping = getMapping(input);

  function getSequence(accumulator, current) {
    const parent = mapping[current];
    if (parent) {
      return getSequence([...accumulator, current], parent);
    }
    return accumulator;
  }

  const youSequence = getSequence([], "YOU");
  const sanSequence = getSequence([], "SAN");

  const intersectionPoint = youSequence.find(value =>
    sanSequence.includes(value)
  );
  const intersectionSequence = getSequence([], intersectionPoint);

  const youLength = youSequence.length;
  const sanLength = sanSequence.length;
  const intersectionLength = intersectionSequence.length;

  console.log("youLength: ", youLength);
  console.log("sanLength: ", sanLength);
  console.log("intersectionLength: ", intersectionLength);

  const result =
    youLength - intersectionLength + (sanLength - intersectionLength);

  return result - 2;
}

describe.only("Day 6: Universal Orbit Map", () => {
  test("part1", () => {
    const input = [
      "COM)B",
      "B)C",
      "C)D",
      "D)E",
      "E)F",
      "B)G",
      "G)H",
      "D)I",
      "E)J",
      "J)K",
      "K)L"
    ];
    expect(calculateOrbits(input)).toBe(42);
    console.log("output: ", calculateOrbits(getInput("day6.txt", "\n")));
  });
  test("part2", () => {
    const input = [
      "COM)B",
      "B)C",
      "C)D",
      "D)E",
      "E)F",
      "B)G",
      "G)H",
      "D)I",
      "E)J",
      "J)K",
      "K)L",
      "K)YOU",
      "I)SAN"
    ];
    expect(calculateMinimumOrbitTransfers(input)).toBe(4);
    console.log("output: ", calculateMinimumOrbitTransfers(getInput("day6.txt", "\n")));
  });
});
