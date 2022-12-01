use std::fs;
use std::io;
mod day1;

fn main() -> io::Result<()> {
    let contents =
        fs::read_to_string("./src/day1.txt").expect("Should have been able to read the file");
    let input: Vec<&str> = contents.split("\n").collect();
    let output = day1::run(input);
    println!("{output}");
    Ok(())
}
