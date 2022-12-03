use std::fs;
use std::io;
mod day3;

fn main() -> io::Result<()> {
    let content =
        fs::read_to_string("./src/day3.txt").expect("Should have been able to read the file");
    let input: Vec<&str> = content.lines().collect();
    day3::run(input).map(|(first, second)| {
        println!(
            "
first: {}
second: {}",
            first, second
        );
    });
    Ok(())
}
