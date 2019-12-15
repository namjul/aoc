const fs = require("fs");

const getInput = (path, separator) => {
  return fs
    .readFileSync(`./inputs/${path}`)
    .toString()
    .split(separator)
    .slice(0, -1);
};

// curry :: ((a, b, ...) -> c) -> a -> b -> ... -> c
function curry(fn) {
  const arity = fn.length;

  return function $curry(...args) {
    if (args.length < arity) {
      return $curry.bind(null, ...args);
    }

    return fn.call(null, ...args);
  };
}

// compose :: ((a -> b), (b -> c),  ..., (y -> z)) -> a -> z
const compose = (...fns) => (...args) =>
  fns.reduceRight((res, fn) => [fn.call(null, ...res)], args)[0];

// takeLast :: Number -> [a] -> [a]
const take = curry((n, a) => a.slice(0, n));

// takeLast :: Number -> [a] -> [a]
const takeLast = curry((n, a) => a.slice(-n));

module.exports = {
  getInput,
  curry,
  compose,
  take,
  takeLast
};
