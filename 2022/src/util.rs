use std::fs;
use std::io;

pub fn read(file: &str) -> io::Result<Vec<String>> {
    return fs::read_to_string(file).map(|content| {
        return content.lines().map(str::to_string).collect::<Vec<String>>();
    });
}
