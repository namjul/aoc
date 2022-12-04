use std::fs;
use std::io;
mod day4;

fn main() -> io::Result<()> {
    let content =
        fs::read_to_string("./src/day4.txt").expect("Should have been able to read the file");
    let input: Vec<&str> = content.lines().collect();
    day4::run(input).map(|(first, second)| {
        println!(
            "
first: {}
second: {}",
            first, second
        );
    });
    Ok(())
}
