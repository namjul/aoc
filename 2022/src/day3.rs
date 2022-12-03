use std::collections::HashSet;
use std::str;

pub fn run(input: Vec<&str>) -> Option<(u32, u32)> {
    static ASCII_LOWER: [char; 52] = [
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
        's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
        'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    ];

    let bb = input.iter().map(|&x| {
        let (compartment_a, compartment_b) = x.split_at(x.len() / 2);

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
    });

    let result1: usize = bb.sum();

    return Some((result1 as u32, 0));
}
