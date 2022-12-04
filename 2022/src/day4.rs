use std::ops::Range;

fn containsFully(r1: Range<u32>, r2: Range<u32>) -> bool {
    let a = r1.start;
    let b = r1.end;
    let c = r2.start;
    let d = r2.end;

    // had to look this up https://www.reddit.com/r/adventofcode/comments/zc557b/2022_day_4_of_max_and_min/
    if c <= a && a <= b && b <= d || (a <= c) && (c <= d) && d <= b {
        return true;
    }

    return false;
}

pub fn run(input: Vec<&str>) -> Option<(u32, u32)> {
    let result1 = input
        .iter()
        .filter_map(|&line| {
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

            if containsFully(first_range, second_range) {
                return Some(true);
            }

            return None;
        })
        .count();

    return Some((result1 as u32, 0));
}
