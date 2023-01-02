fn part1() -> i32 {
    let input = std::fs::read_to_string("./src/bin/day10.prod.txt").unwrap();
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

    total
}


// with help from https://dev.to/nickymeuleman/advent-of-code-2022-day-10-bi5

const COLS: usize = 40;
const ROWS: usize = 6;
const SPRITE_WIDTH: u32 = 3;

// Cycle   1 -> #yyy#################################### <- Cycle  40
// Cycle  41 -> ######################################## <- Cycle  80
// Cycle  81 -> ######################################## <- Cycle 120
// Cycle 121 -> ######################################## <- Cycle 160
// Cycle 161 -> ######################################## <- Cycle 200
// Cycle 201 -> ######################################## <- Cycle 240

fn get_pixel(cycle: usize, register: i32) -> char {
    let current_col = (cycle - 1) % COLS;

    if (current_col as i32).abs_diff(register) <= 1 {
        return '#';
    }
    '.'
}

fn main() -> std::io::Result<()> {
    let mut register = 1;
    let mut cycle = 1;
    let mut screen = [' '; COLS * ROWS];

    let input = std::fs::read_to_string("./src/bin/day10.prod.txt").unwrap();
    let lines = input.lines();

    for line in lines {
        screen[cycle - 1] = get_pixel(cycle, register);
        cycle += 1;

        if let Some(("addx", num)) = line.split_once(' ') {
            screen[cycle - 1] = get_pixel(cycle, register);
            cycle += 1;
            let num: i32 = num.parse().unwrap();
            register += num;
        }
    }

    let image = screen
        .chunks(COLS)
        .map(|row| row.iter().collect())
        .collect::<Vec<String>>()
        .join("\n");

    println!("{}", image);

    Ok(())
}
