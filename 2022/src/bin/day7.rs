use std::io;

// https://dev.to/deciduously/no-more-tears-no-more-knots-arena-allocated-trees-in-rust-44k6
// https://applied-math-coding.medium.com/a-tree-structure-implemented-in-rust-8344783abd75

// #[derive(Debug, Default)]
// struct ArenaTree<T: PartialEq> {
//     arena: Vec<Node<T>>,
// }
//
// impl<T> ArenaTree<T>
// where
//     T: PartialEq,
// {
//     fn node(&mut self, val: T) -> usize {
//         //first see if it exists
//         for node in &self.arena {
//             if node.val == val {
//                 return node.idx;
//             }
//         }
//         // Otherwise, add new node
//         let idx = self.arena.len();
//         self.arena.push(Node::new(idx, val));
//         idx
//     }
//     fn insert(&mut self, parent: T, child: T) {
//         let parent_idx = self.node(parent);
//         let child_idx = self.node(child);
//
//         match self.arena[child_idx].parent {
//             Some(_) => println!("Attempt to overwrite existing orbit"),
//             None => self.arena[child_idx].parent = Some(parent_idx),
//         }
//         // set parents
//         self.arena[parent_idx].children.push(child_idx);
//     }
// }
//
// #[derive(Debug)]
// struct Node<T: PartialEq> {
//     idx: usize,
//     val: T,
//     parent: Option<usize>,
//     children: Vec<usize>,
// }
//
// impl<T> Node<T>
// where
//     T: PartialEq,
// {
//     fn new(idx: usize, val: T) -> Self {
//         Self {
//             idx,
//             val,
//             parent: None,
//             children: vec![],
//         }
//     }
// }
//
// #[derive(Debug, Default, Clone, PartialEq)]
// struct FileSystemObject {
//     name: String,
//     size: Option<u32>,
// }

// with help from https://www.twitch.tv/videos/1672855137?filter=all&sort=time

pub fn main() -> io::Result<()> {
    let input = std::fs::read_to_string("./src/bin/day7.txt")?;

    let mut stack = vec![("/", 0)];
    let mut sizes_stack = vec![];

    let total_fs_size = 70000000;
    let minimum_fs_update_size = 30000000;
    let max_size = 100000;
    let mut total_max_size = 0;
    let mut total = 0;

    for line in input.lines().filter(|l| !l.is_empty()) {
        if line == "$ cd /" || line == "$ ls" {
            continue;
        }

        if line.starts_with("$ cd ") {
            let dir = &line[5..];
            if dir == ".." {
                let (name, amount) = stack.pop().unwrap();
                if amount <= max_size {
                    total_max_size += amount;
                }
                sizes_stack.push((name, amount));
                stack.last_mut().unwrap().1 += amount;
            } else {
                stack.push((dir, 0));
            }
        }

        let (amount, _) = line.split_once(" ").unwrap();

        if let Ok(amount) = amount.parse::<usize>() {
            total += amount;
            stack.last_mut().unwrap().1 += amount;
        } else {
            // ignore
        }
    }

    // sizes_stack.push(stack.pop().unwrap());

    let unused_space = total_fs_size - total;
    let space_to_free = minimum_fs_update_size - unused_space;

    let dirsize_to_delete = sizes_stack
        .iter()
        .filter(|(_, size)| size >= &space_to_free)
        .min();

    println!("stack: {:#?}", stack);
    println!("sizes stack: {:#?}", sizes_stack);
    println!("total_max_size: {}", total_max_size);
    println!("total: {}", total);
    println!("unused_space: {}", unused_space);
    println!("space to free: {}", space_to_free);
    println!("dirsize to delete {:#?}", dirsize_to_delete);

    Ok(())
}
