use aoc_2022::read;
use std::io;

fn parse(input: Vec<&String>) -> Vec<Vec<char>> {
    let mut x: Vec<_> = input
        .iter()
        .map(|&x| x.chars().collect::<Vec<_>>())
        .collect();

    let index_stackes = x
        .pop()
        .map(|x| {
            return x
                .iter()
                .enumerate()
                .filter_map(|(index, char)| {
                    return char.to_string().parse::<i32>().map_or(None, |_v| {
                        return Some(index);
                    });
                })
                .collect::<Vec<usize>>();
        })
        .unwrap();

    let mut v: Vec<Vec<char>> = vec![];

    index_stackes.iter().for_each(|&index| {
        let mut vv: Vec<char> = vec![];
        let xx = x.iter().rev().filter_map(|row| {
            let item = row[index];
            if item == ' ' {
                return None;
            }
            return Some(item);
        });
        vv.extend(xx);
        v.push(vv);
    });

    return v;
}

fn move_creates_cratemover_9000<'a>(
    stacks: &'a mut Vec<Vec<char>>,
    command: &'a (usize, usize, usize),
) -> &'a Vec<Vec<char>> {
    let (mv, from, to) = command;

    // println!("move: {}, from: {}, to: {}", mv, from, to);

    for _n in 0..*mv {
        let kiste = &stacks[*from - 1].pop().unwrap();
        let _ = &stacks[*to - 1].push(*kiste);
    }

    // println!("stacks: {:#?}", stacks);

    return stacks;
}

fn move_creates_cratemover_9001<'a>(
    stacks: &'a mut Vec<Vec<char>>,
    command: &'a (usize, usize, usize),
) -> &'a Vec<Vec<char>> {
    let (mv, from, to) = command;

    // println!("move: {}, from: {}, to: {}", mv, from, to);

    let from_stack = &stacks[*from - 1];
    let mut to_stack = &stacks[*to - 1];

    let x = from_stack.iter().rev().take(*mv).collect::<Vec<_>>();

    x.iter().for_each(|&v| {
        to_stack.push(*v);
    });

    // println!("stacks: {:#?}", stacks);

    return stacks;
}

pub fn main() -> io::Result<()> {
    return read("./src/bin/day5.txt")
        .map(|lines| {
            let (commands_input, stacks_input): (Vec<_>, Vec<_>) = lines
                .iter()
                .filter(|&n| n != "")
                .partition(|&n| n.starts_with("m"));

            let mut stacks = parse(stacks_input);

            let commands = commands_input
                .iter()
                .map(|&n| {
                    let v = n
                        .split_whitespace()
                        .filter_map(|x| {
                            return x.parse::<usize>().map_or(None, |value| {
                                return Some(value);
                            });
                        })
                        .collect::<Vec<_>>();
                    let num_pair: (usize, usize, usize) = (v[0], v[1], v[2]);
                    return num_pair;
                })
                .collect::<Vec<_>>();

            commands.iter().for_each(|command| {
                move_creates_cratemover_9001(&mut stacks, command);
            });

            return stacks
                .iter()
                .map(|current| {
                    return current.last().clone().unwrap().to_string();
                }).fold(String::from(""), |accum, current| {
                    return accum + &current ;
                });

        })
        .map(|result| {
            println!("Result: {:#?}", result);
            return ();
        });
}
