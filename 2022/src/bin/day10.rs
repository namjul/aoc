fn main() -> std::io::Result<()> {
    let input = std::fs::read_to_string("./src/bin/day10.prod.txt")?;
    let lines = input.lines();

    let mut register = 1;
    let mut total = 0;
    let mut cycle = 1;

    for line in lines {
        if cycle % 40 == 20 {
            total += cycle * register;
        }

        cycle += 1;

        if let Some(("addx", num)) = line.split_once(' ') {

        if cycle % 40 == 20 {
            total += cycle * register;
        }

            let num: i32 = num.parse().unwrap();
            cycle += 1;
            register += num;
        }
    }

    println!("{}", total);

    Ok(())
}
