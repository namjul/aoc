pub fn run(input: Vec<&str>) -> Option<(u32, u32)> {
    let yy: u32 = input
        .iter()
        .map(|&x| {
            let x: Vec<&str> = x.split_whitespace().collect();

            let a = *x.first().unwrap();
            let b = *x.last().unwrap();

            // "A" | "X" => Rock(1),
            // "B" | "Y" => Paper(2),
            // "C" | "Z" => Scissors(3),
            let result = match (a, b) {
                ("A", "X") => 1+3,
                ("A", "Y") => 2+6,
                ("A", "Z") => 3+0,
                ("B", "X") => 1+0,
                ("B", "Y") => 2+3,
                ("B", "Z") => 3+6,
                ("C", "X") => 1+6,
                ("C", "Y") => 2+0,
                ("C", "Z") => 3+3,
                _ => 0,
            };


            return result
        })
        .sum();

    return Some((yy, 0))
}
