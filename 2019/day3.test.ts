import { getInput } from "./utils";

const reduce = (callback, startValue) => array =>
  array.reduce(callback, startValue);
const map = callback => array => array.map(callback);
const identiy = value => value;
const filter = callback => array => array.filter(callback);
const flatMap = callback => array =>
  Array.prototype.concat(...array.map(callback));

const compose = (...fns) =>
  fns.reduceRight(
    (prevFn, nextFn) => (...args) => nextFn(prevFn(...args)),
    value => value
  );

const commaSplit = string => string.split(",");
const tap = callback => value => {
  callback(value);
  return value;
};

type Down = "D";
type Up = "U";
type Right = "R";
type Left = "L";
type Direction = Down | Up | Right | Left;

type Point = {
  x: number;
  y: number;
};

type Command = {
  command: Direction;
  amount: number;
};

const min = array => Math.min(...array);

const convertToDistance = (
  points: Array<Point>,
  { command, amount }: Command
) => {
  const lastPoint = points[points.length - 1];

  let x: number;
  let y: number;

  switch (command) {
    case "U":
      y = lastPoint.y + amount;
      x = lastPoint.x;
      break;
    case "D":
      y = lastPoint.y - amount;
      x = lastPoint.x;
      break;
    case "L":
      x = lastPoint.x - amount;
      y = lastPoint.y;
      break;
    case "R":
      x = lastPoint.x + amount;
      y = lastPoint.y;
      break;
    default:
  }

  return [...points, { x, y }];
};

const calcPointDistance = (point: Point): number =>
  Math.abs(point.x) + Math.abs(point.y);

const parseToDirection = (command: string): Command => {
  const [_, group1, group2] = new RegExp("([UDLR])([0-9]*)", "g").exec(command);
  return {
    command: group1 as Direction,
    amount: Number(group2)
  };
};

const compareWires = (
  compareFunction,
  wireA: Array<Point>,
  wireB: Array<Point>
): Array<Point> => {
  for (let i = 0, lenA = wireA.length; i < lenA; i++) {
    if (i === 0) {
      continue;
    }
    const edgeA = [wireA[i - 1], wireA[i]];

    for (var j = 0, len = wireB.length; j < len; j++) {
      if (j === 0) {
        continue;
      }
      const edgeB = [wireB[j - 1], wireB[j]];
      compareFunction(edgeA, edgeB);
    }
  }
  return [];
};

const getInbetweenPoints = (pointA: Point, pointB: Point) => {
  const [axis, constantAxis] = pointA.x === pointB.x ? ["y", "x"] : ["x", "y"];
  const range = [pointA[axis], pointB[axis]];
  const result = [];
  for (var i = Math.min(...range), len = Math.max(...range); i <= len; i++) {
    result.push({
      [constantAxis]: pointA[constantAxis],
      [axis]: i
    });
  }

  return result;
};

const intersectionPoint = (
  [pointA, pointB],
  [pointC, pointD]
): Point | undefined => {
  const otherPoints = getInbetweenPoints(pointC, pointD);

  const result = getInbetweenPoints(pointA, pointB).filter(point =>
    otherPoints.find(
      otherPoint => point.x === otherPoint.x && point.y === otherPoint.y
    )
  );

  return result[0];
};

const getCrossPoints = (accumulator, current, currentIndex, array) => {
  const wire = current;
  const restWires = array.slice(currentIndex + 1);

  restWires.forEach(currentWire => {
    compareWires(
      (edgeA, edgeB) => {
        const point = intersectionPoint(edgeA, edgeB);

        if (point) {
          accumulator.push(point);
        }
      },
      wire,
      currentWire
    );
  });

  return accumulator;
};

function calcManhattenDistance(input: Array<string>) {
  return compose(
    tap(value => console.log("value: ", value)),
    min,
    filter(identiy),
    map(calcPointDistance),
    reduce(getCrossPoints, []),
    map(
      compose(
        reduce(convertToDistance, [{ x: 0, y: 0 }]),
        map(parseToDirection),
        commaSplit
      )
    )
  )(input);
}

describe("Day 3: Crossed Wires", () => {
  test("part1", () => {
    expect(calcManhattenDistance(["R8,U5,L5,D3", "U7,R6,D4,L4"])).toEqual(6);
    expect(
      calcManhattenDistance([
        "R75,D30,R83,U83,L12,D49,R71,U7,L72",
        "U62,R66,U55,R34,D71,R55,D58,R83"
      ])
    ).toEqual(159);
    expect(
      calcManhattenDistance([
        "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
        "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
      ])
    ).toEqual(135);
    calcManhattenDistance(getInput("day3.txt", "\n"));
  });
  // test("part2", () => {});
});
