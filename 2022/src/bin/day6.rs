use aoc_2022::read;
use std::collections::HashSet;
use std::io;

pub fn main() -> io::Result<()> {
    return read("./src/bin/day6.txt").map(|input| {
        let datastream = &input[0];

        let chars = datastream.chars().into_iter().collect::<Vec<_>>();

        for (index, _char) in chars.iter().enumerate() {
            let cursor = if index >= 4 { index - 3 } else { 0 };

            let mut set = HashSet::new();
            for n in cursor..(index + 1) {
                set.insert(chars[n]);
            }

            if set.len() == 4 {
                println!("found marker at {}", index + 1);
                return ();
            }
        }

        return ();
    });
}
