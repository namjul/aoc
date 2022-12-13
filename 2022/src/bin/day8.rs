fn check(grid: &Vec<Vec<usize>>, position: (usize, usize)) -> usize {
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

    let result = [left_side, right_side, top_size, bottom_size]
        .iter()
        .map(|x| {
            let mut acc = 0;
            for n in x.iter() {
                if **n < value {
                    acc += 1;
                } else {
                    acc += 1;
                    break;
                }
            }
            return acc;
        })
        .fold(1, |acc, current| {
            return acc * current;
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
    let mut scenic_scores = vec![];

    for (index_y, row) in grid.iter().enumerate() {
        for (index_x, _col) in row.iter().enumerate() {
            if index_y == 0 || index_y == grid.len() - 1 {
                edges_amount += 1;
                continue;
            }

            if index_x == 0 || index_x == row.len() - 1 {
                edges_amount += 1;
                continue;
            }

            scenic_scores.push(check(&grid, (index_x, index_y)));
        }
    }

    println!("grid: {:#?}", grid);
    println!("edges_amount: {:#?}", edges_amount);
    println!("scenic_scores: {:#?}", scenic_scores.iter().max());

    Ok(())
}
