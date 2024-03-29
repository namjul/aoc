pub fn run(input: Vec<&str>) -> Option<(u32, u32)> {
    let mut vec: Vec<u32> = Vec::new();
    let mut value: u32 = 0;
    for line in input {
        let num = line.parse().unwrap_or(0);line.parse().unwrap_or(0);
        value = value + num;
        if num == 0 {
            vec.push(value);
            value = 0;
        }
    }
    vec.sort();
    let last3 = vec.into_iter().rev().take(3).rev();
    let sum: u32 = last3.clone().sum();
    return last3.last().map(|max| ((max, sum)));
}
