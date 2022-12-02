pub fn run(input: Vec<&str>) -> Option<(u32, u32)> {

    let yy: u32 = input
        .iter()
        .map(|&x| {
            let xx: Vec<&str> = x.split_whitespace().collect();

            let a = *xx.first().unwrap();
            let b = *xx.last().unwrap();

            // "A" | "X" => Rock(1),
            // "B" | "Y" => Paper(2),
            // "C" | "Z" => Scissors(3),
            let result1 = match (a, b) {
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

            // "X" => Lose
            // "Y" => Draw
            // "Z" => Win
            let result2 = match (a, b) {
                ("A", "X") => 3+0, // Z+Lose
                ("A", "Y") => 1+3, // A+Draw
                ("A", "Z") => 2+6, // B+Win
                ("B", "X") => 1+0, // A+Lose
                ("B", "Y") => 2+3, // B+Draw
                ("B", "Z") => 3+6, // C+Win
                ("C", "X") => 2+0, // Y+Lose
                ("C", "Y") => 3+3, // Z+Draw
                ("C", "Z") => 1+6, // X+Win
                _ => 0,
            };


            return result2
        })
        .sum();

    return Some((yy, 0))
}
