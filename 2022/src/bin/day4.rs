use aoc_2022::read;
use std::io;
use std::ops::Range;

fn contains_fully(r1: Range<u32>, r2: Range<u32>) -> bool {
    let a = r1.start;
    let b = r1.end;
    let c = r2.start;
    let d = r2.end;

    if a <= c && d <= b || a >= c && b <= d {
        return true;
    }

    return false;
}


// ....567..  5-7
// ......789  7-9
//
// ....567..  5-7
// ..345....  3-5

fn overlap(r1: Range<u32>, r2: Range<u32>) -> bool {
    let a = r1.start;
    let b = r1.end - 1;
    let c = r2.start;
    let d = r2.end - 1;

    if a <= c && b >= c || a >= c && d >= a {
        return true;
    }

    return false;
}

pub fn main() -> io::Result<()> {
    return read("./src/bin/day4.txt")
        .map(|line| {
            let result1 = line
                .iter()
                .filter_map(|line| {
                    let to_range = |range: &str| {
                        return range
                            .split_once("-")
                            .map(|(first, last)| {
                                return first
                                    .parse()
                                    .and_then(|first_num: u32| {
                                        last.parse().map(|last_num: u32| (first_num..last_num + 1))
                                    })
                                    .unwrap();
                            })
                            .unwrap();
                    };

                    let (first, second) = line.split_once(",").unwrap();

                    let first_range = to_range(first);
                    let second_range = to_range(second);

                    if overlap(first_range, second_range) {
                        return Some(true);
                    }

                    return None;
                })
                .count();
            return result1;
        })
        .map(|result| {
            println!("Result: {}", result);
            return ();
        });
}
