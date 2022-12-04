use aoc_2022::read;
use std::collections::HashSet;
use std::io;

pub fn main() -> io::Result<()> {
    return read("./src/bin/day4.txt")
        .map(|lines| {
            static ASCII_LOWER: [char; 52] = [
                'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p',
                'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F',
                'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
                'W', 'X', 'Y', 'Z',
            ];

            let xx: usize = lines.iter().map(|line| {
                let (compartment_a, compartment_b) = line.split_at(line.len() / 2);

                let a: HashSet<_> = HashSet::from_iter(compartment_a.chars().into_iter());
                let b: HashSet<_> = HashSet::from_iter(compartment_b.chars().into_iter());

                let intersection: HashSet<_> = a
                    .intersection(&b)
                    .map(|x| {
                        return x;
                    })
                    .collect();

                let priority: usize = intersection
                    .iter()
                    .map(|&&x| {
                        return ASCII_LOWER.iter().position(|&r| r == x).unwrap_or(0) + 1;
                    })
                    .sum();

                return priority;
            }).sum();

            return xx;

        })
        .map(|result| {
            println!("Result: {}", result);
            return ();
        });
}
