fn check(grid: &Vec<Vec<usize>>, position: (usize, usize)) -> bool {
    let (x, y) = position;

    let left_side: Vec<&usize> = vec![x; x]
        .iter()
        .enumerate()
        .map(|(index, _)| &grid[y][index])
        .rev()
        .collect();
    let right_side: Vec<&usize> = vec![x + 1; grid[y].len() - (x + 1)]
        .iter()
        .enumerate()
        .map(|(index, count)| &grid[y][index + count])
        .collect();
    let top_size: Vec<&usize> = vec![0; y]
        .iter()
        .enumerate()
        .map(|(index, _)| &grid[index][x])
        .rev()
        .collect();
    let bottom_size: Vec<&usize> = vec![y + 1; grid.len() - 1 - y]
        .iter()
        .enumerate()
        .map(|(index, count)| &grid[index + count][x])
        .collect();
    let value = grid[y][x];

    // println!("value: {}", value);
    // println!("left_side: {:#?}", left_side);
    // println!("right_side: {:#?}", right_side);
    // println!("top_size: {:#?}", top_size);
    // println!("bottom_size: {:#?}", bottom_size);

    let a = [left_side, right_side, top_size, bottom_size];

    let result = a.iter().fold(false, |acc, x| {
        if value > **x.iter().max().unwrap() {
            return true;
        }
        return acc;
    });

    return result;

}

fn main() -> std::io::Result<()> {
    let mut grid: Vec<Vec<usize>> = vec![];

    let input = std::fs::read_to_string("./src/bin/day8.prod.txt")?;

    for (index_y, line_y) in input.lines().enumerate() {
        grid.push(vec![]);
        for value in line_y.chars() {
            if let Some(value) = value.to_digit(10) {
                grid[index_y].push(value as usize);
            }
        }
    }

    let mut edges_amount = 0;

    for (index_y, row) in grid.iter().enumerate() {
        for (index_x, col) in row.iter().enumerate() {
            if index_y == 0 || index_y == grid.len() - 1 {
                edges_amount += 1;
                continue;
            }

            if index_x == 0 || index_x == row.len() - 1 {
                edges_amount += 1;
                continue;
            }

            if check(&grid, (index_x, index_y)) {
                edges_amount += 1;
            }
        }
    }

    println!("grid: {:#?}", grid);
    println!("edges_amount: {:#?}", edges_amount);

    Ok(())
}
