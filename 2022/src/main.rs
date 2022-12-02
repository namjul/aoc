use std::fs;
use std::io;
mod day1;

fn main() -> io::Result<()> {
    let content =
        fs::read_to_string("./src/day1.txt").expect("Should have been able to read the file");
    let input: Vec<&str> = content
        .lines()
        .collect();
    let (first, second) = day1::run(input).unwrap();
    println!(
        "
first: {}
second: {}",
        first, second
    );
    Ok(())
}
