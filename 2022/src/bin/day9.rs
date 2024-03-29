use std::collections::HashSet;

// == Initial State ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ...........H..............  (H covers 1, 2, 3, 4, 5, 6, 7, 8, 9, s)
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
//
// == R 5 ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ................h.........
// ................1.........
// ................2.........
// ................3.........
// ...........87654..........  (5 covers 6, 7, 8, 9, s)
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
//
// == U 8 ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ................H.........
// ................1.........
// ................2.........
// ................3.........
// ...............54.........
// ..............6...........
// .............7............
// ............8.............
// ...........9..............  (9 covers s)
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
//
// == L 8 ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ........H1234.............
// ............5.............
// ............6.............
// ............7.............
// ............8.............
// ............9.............
// ..........................
// ..........................
// ...........s..............
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
//
// == D 3 ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// .........2345.............
// ........1...6.............
// ........H...7.............
// ............8.............
// ............9.............
// ..........................
// ..........................
// ...........s..............
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
//
// == R 17 ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ................987654321H
// ..........................
// ..........................
// ..........................
// ..........................
// ...........s..............
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
//
// == D 10 ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ...........s.........98765
// .........................4
// .........................3
// .........................2
// .........................1
// .........................H
//
// == L 25 ==
//
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ...........s..............
// ..........................
// ..........................
// ..........................
// ..........................
// H123456789................
//
// == U 20 ==
//
// H.........................
// 1.........................
// 2.........................
// 3.........................
// 4.........................
// 5.........................
// 6.........................
// 7.........................
// 8.........................
// 9.........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ...........s..............
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................

// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// ..........................
// #.........................
// #.............###.........
// #............#...#........
// .#..........#.....#.......
// ..#..........#.....#......
// ...#........#.......#.....
// ....#......s.........#....
// .....#..............#.....
// ......#............#......
// .......#..........#.......
// ........#........#........
// .........########.........

#[derive(Clone, Copy, Debug)]
enum Move {
    Right(u8),
    Left(u8),
    Down(u8),
    Up(u8),
}

impl Move {
    fn get_distance(self) -> u8 {
        match self {
            Move::Right(dist) => dist,
            Move::Left(dist) => dist,
            Move::Up(dist) => dist,
            Move::Down(dist) => dist,
        }
    }
}

impl std::str::FromStr for Move {
    type Err = std::string::ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (direction, steps) = s
            .split_once(" ")
            .map(|(direction, steps)| return (direction, steps.parse::<u8>().unwrap()))
            .unwrap();

        Ok(match direction {
            "R" => Move::Right(steps),
            "L" => Move::Left(steps),
            "U" => Move::Up(steps),
            "D" => Move::Down(steps),
            _ => panic!("Wrong command format"),
        })
    }
}

#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq)]
struct Position {
    x: isize,
    y: isize,
}

#[derive(Debug)]
struct Rope<const N: usize> {
    knots: [Position; N],
}

impl<const N: usize> Rope<N> {
    fn new() -> Rope<N> {
        Rope {
            knots: [Position { x: 0, y: 0 }; N],
        }
    }

    fn update_tail(&mut self) {
        for i in 0..self.knots.len() - 1 {
            let head: Position = self.knots[i];
            let tail = &mut self.knots[i + 1];

            // move tail on the x-axis
            let diff_x = head.x - tail.x;
            let diff_y = head.y - tail.y;

            // move tail on the x-axis
            if diff_x.abs() > 1 {
                if diff_x > 0 {
                    tail.x += 1;
                } else {
                    tail.x -= 1;
                }

                if diff_y.abs() > 1 {
                    if diff_y > 0 {
                        tail.y += 1;
                    } else {
                        tail.y -= 1;
                    }
                }
                break;
            }

            // move tail on the y-axis
            if diff_y.abs() > 1 {
                if diff_y > 0 {
                    tail.y += 1;
                } else {
                    tail.y -= 1;
                }

                if diff_x.abs() > 1 {
                    if diff_x > 0 {
                        tail.x += 1;
                    } else {
                        tail.x -= 1;
                    }
                }
            }
        }
    }

    fn tail_pos(&mut self) -> Position {
        return *self.knots.last().unwrap_or(&Position { x: 0, y: 0 });
    }

    fn move_right(&mut self) {
        self.knots[0].x += 1;
        self.update_tail();
    }

    fn move_left(&mut self) {
        self.knots[0].x -= 1;
        self.update_tail();
    }

    fn move_up(&mut self) {
        self.knots[0].y += 1;
        self.update_tail();
    }

    fn move_down(&mut self) {
        self.knots[0].y -= 1;
        self.update_tail();
    }
}

// fn calc_tail_position(tail: &mut Position, head: &mut Position) -> (isize, isize) {
//     if tail == head {
//         return (tail.0, tail.1);
//     }
//
//     // move tail on the x-axis
//     let x_offset = head.0 - tail.0;
//     if x_offset < -1 || x_offset > 1 {
//         if x_offset > 0 {
//             tail.0 += 1;
//         } else {
//             tail.0 -= 1;
//         }
//         if head.1 != tail.1 {
//             tail.1 = head.1;
//         }
//     }
//
//     // move tail on the y-axis
//     let y_offset = head.1 - tail.1;
//     if y_offset < -1 || y_offset > 1 {
//         if y_offset > 0 {
//             tail.1 += 1;
//         } else {
//             tail.1 -= 1;
//         }
//
//         if head.0 != tail.0 {
//             tail.0 = head.0;
//         }
//     }
//
//     println!("new tail position: {:#?}", tail);
//
//     return (tail.0, tail.1);
// }

fn main() -> std::io::Result<()> {
    let mut rope: Rope<10> = Rope::new();
    let mut tail_positions = HashSet::new();
    // println!("{:#?}", rope.tail_pos());
    tail_positions.insert(rope.tail_pos());
    // println!("{:#?}", tail_positions);

    let input = std::fs::read_to_string("./src/bin/day9.test.txt")?;
    let lines = input.lines();
    let moves = lines.clone().map(|l| l.parse::<Move>().unwrap());

    for m in moves {
        for step in 1..m.get_distance() + 1 {
            println!("{} of {:#?}", step, m);
            match m {
                Move::Right(_) => {
                    rope.move_right();
                }
                Move::Left(_) => {
                    rope.move_left();
                }
                Move::Up(_) => {
                    rope.move_up();
                }
                Move::Down(_) => {
                    rope.move_down();
                }
            }
            let tail = rope.tail_pos();
            println!("tail: {tail:?}");
            tail_positions.insert(tail);
            println!("knots: {:#?}", rope.knots);
        }
    }

    // println!("snake: {:#?}", rope);
    println!("{:#?}", tail_positions);
    println!("{}", tail_positions.len());

    return Ok(());
}
