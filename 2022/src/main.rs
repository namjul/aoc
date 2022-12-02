use std::fs;
use std::io;
mod day2;

fn main() -> io::Result<()> {
    let content =
        fs::read_to_string("./src/day2.txt").expect("Should have been able to read the file");
    let input: Vec<&str> = content.lines().collect();
    day2::run(input).map(|(first, second)| {
        println!(
            "
first: {}
second: {}",
            first, second
        );
    });
    Ok(())
}
