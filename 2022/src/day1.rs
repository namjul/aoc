pub fn run(input: Vec<&str>) -> (u32, u32) {
    let mut vec: Vec<u32> = Vec::new();
    let mut current_group: u32 = 0;
    for line in input {
        if line != "" {
            let x: u32 = line.parse().unwrap();
            current_group = current_group + x;
        } else {
            vec.push(current_group);
            current_group = 0;
        }
    }
    vec.sort();
    let max = *vec.last().unwrap();
    let last3: u32 = vec.into_iter().rev().take(3).sum();
    return (max, last3);
}
