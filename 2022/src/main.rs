use std::fs;
use std::io;
mod day1;

fn main() -> io::Result<()> {
    let content =
        fs::read_to_string("./src/day1.txt").expect("Should have been able to read the file");
    let input: Vec<u32> = content
        .split("\n")
        .map(|x| x.parse::<u32>().unwrap_or(0))
        .collect();
    let output = day1::run(input);
    println!("{:#?}", output);
    Ok(())
}
