pub fn run(input: Vec<u32>) -> (u32, u32) {
    let mut vec: Vec<u32> = Vec::new();
    let mut value: u32 = 0;
    for num in input {
        value = value + num;
        if num == 0 {
            vec.push(value);
            value = 0;
        }
    }
    vec.sort();
    let max = *vec.last().unwrap();
    let last3: u32 = vec.into_iter().rev().take(3).sum();
    return (max, last3);
}
