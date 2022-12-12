use aoc_2022::read;
use std::collections::HashSet;
use std::io;

pub fn main() -> io::Result<()> {
    return read("./src/bin/day6.txt").map(|input| {
        let datastream = &input[0];

        let chars = datastream.chars().into_iter().collect::<Vec<_>>();

        let start_of_message = 14;

        for (index, _char) in chars.iter().enumerate() {
            let cursor = if index >= start_of_message { index - (start_of_message - 1) } else { 0 };

            let mut set = HashSet::new();
            for n in cursor..(index + 1) {
                set.insert(chars[n]);
            }

            if set.len() == start_of_message {
                println!("found marker at {}", index + 1);
                return ();
            }
        }

        return ();
    });
}
