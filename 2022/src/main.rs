use std::io;
mod day4;
mod util;

fn main() -> io::Result<()> {
    return util::read("./src/day4.txt").map(|input| {
        day4::run(input).map(|(first, second)| {
            println!(
                "
first: {}
second: {}",
                first, second
            );
        });
    });

}
