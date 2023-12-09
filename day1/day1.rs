use std::{
    fs::File,
    io::{self, BufRead, BufReader},
    path::Path,
};

fn lines_from_file(filename: impl AsRef<Path>) -> io::Result<Vec<String>> {
    BufReader::new(File::open(filename)?).lines().collect()
}

fn main() {
    let lines = lines_from_file("day1.in").expect("Could not load lines");
    let mut sum = 0;

    for line in lines {
        let left_number = line.chars().find(|c| c.is_digit(10))
            .map(|c| c.to_digit(10).unwrap() as i32).unwrap_or(-1);
        
        let right_number = line.chars().rev().find(|c| c.is_digit(10))
            .map(|c| c.to_digit(10).unwrap() as i32).unwrap_or(-1);

        sum += left_number * 10 + right_number;
    }

    println!("{}", sum);
}