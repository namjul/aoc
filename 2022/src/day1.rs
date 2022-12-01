fn star1(input: Vec<&str>) -> u32 {
    let mut result: u32 = 0;
    let mut current_group: u32 = 0;
    for line in input {
        if line != "" {
            let x: u32 = line.parse().unwrap();
            current_group = current_group + x;
        } else {
            if current_group >= result {
                result = current_group;
            }
            current_group = 0;
        }
    }
    result
}

fn star2(input: Vec<&str>) -> u32 {
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
    vec.into_iter().rev().take(3).sum()
}

pub fn run(input: Vec<&str>) -> u32 {
    star2(input)
}
