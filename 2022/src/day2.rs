pub fn run(input: Vec<&str>) -> Option<(u32, u32)> {
    let bb = input.iter().map(|&x| {
        let mut split = x.split_whitespace();
        let game = (split.next().unwrap(), split.next().unwrap());

        // "A" | "X" => Rock(1),
        // "B" | "Y" => Paper(2),
        // "C" | "Z" => Scissors(3),
        let game1 = match game {
            ("A", "X") => 1 + 3,
            ("A", "Y") => 2 + 6,
            ("A", "Z") => 3 + 0,
            ("B", "X") => 1 + 0,
            ("B", "Y") => 2 + 3,
            ("B", "Z") => 3 + 6,
            ("C", "X") => 1 + 6,
            ("C", "Y") => 2 + 0,
            ("C", "Z") => 3 + 3,
            _ => 0,
        };

        // "A" | "X" => Rock(1),
        // "B" | "Y" => Paper(2),
        // "C" | "Z" => Scissors(3),
        let game2 = match game {
            ("A", "X") => 3 + 0, // Z+Lose
            ("A", "Y") => 1 + 3, // A+Draw
            ("A", "Z") => 2 + 6, // B+Win
            ("B", "X") => 1 + 0, // A+Lose
            ("B", "Y") => 2 + 3, // B+Draw
            ("B", "Z") => 3 + 6, // C+Win
            ("C", "X") => 2 + 0, // Y+Lose
            ("C", "Y") => 3 + 3, // Z+Draw
            ("C", "Z") => 1 + 6, // X+Win
            _ => 0,
        };

        return (game1, game2)
    });

    let result1: u32 = bb.clone().map(|(x, _)| x).sum();
    let result2: u32 = bb.map(|(_, x)| x).sum();

    return Some((result1, result2));
}
