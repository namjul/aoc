fn main() -> std::io::Result<()> {
    let input = std::fs::read_to_string("./src/bin/day10.prod.txt")?;
    let mut lines = input.lines();

    let mut register = 1;
    let mut in_addx_phase: Option<(i32, &str)> = None;
    let mut signals: Vec<i32> = vec![];
    let cycles = [20, 60, 100, 140, 180, 220];

    for n in 1..300 {
        if in_addx_phase.is_some() {
            match in_addx_phase.as_mut() {
                Some(v) if v.0 == 1 => *v = (v.0 + 1, v.1),
                Some(v) => {
                    let x: i32 =
                        v.1.split_once(" ")
                            .map(|(_, amount)| {
                                // println!("amount {}", amount);
                                return amount.parse().unwrap();
                            })
                            .unwrap();
                    register += x;
                    in_addx_phase = None;
                }
                None => {}
            }
        }

        if in_addx_phase.is_none() {
            let instruction = lines.next();

            match instruction {
                Some(x) if x == "noop" => println!("noop"),
                Some(x) => {
                    in_addx_phase = Some((1, x));
                }
                None => (),
            }
        }

        println!("clock: {}, {:#?}, {}", n, in_addx_phase, register);

        if cycles.contains(&n) {
            println!("{n}, {register}");
            signals.push(n * register);
        }

        // println!("R: {}", register);
    }

    let x: i32 = signals.iter().sum();

    println!("R: {}, S: {:#?}, {}", register, signals, x);

    Ok(())
}
