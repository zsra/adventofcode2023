use std::{
    fs::File,
    io::{self, BufRead, BufReader},
    path::Path,
};

fn lines_from_file(filename: impl AsRef<Path>) -> io::Result<Vec<String>> {
    BufReader::new(File::open(filename)?).lines().collect()
}

fn get_substring(s: &str, start_index: usize, length: usize) -> Option<&str> {
    if start_index <= s.len() && start_index + length <= s.len() {
        Some(&s[start_index..start_index + length])
    } else {
        None
    }
}

fn check_string_number(line: &str, number: &mut i32, index: usize) {
    if line.chars().nth(index).unwrap() == 'o' {
        if get_substring(line, index, "one".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "one"
        {
            *number = 1;
        }
    }

    if line.chars().nth(index).unwrap() == 't' {
        if get_substring(line, index, "two".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "two"
        {
            *number = 2;
        }

        if get_substring(line, index, "three".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "three"
        {
            *number = 3;
        }
    }

    if line.chars().nth(index).unwrap() == 'f' {
        if get_substring(line, index, "four".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "four"
        {
            *number = 4;
        }

        if get_substring(line, index, "five".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "five"
        {
            *number = 5;
        }
    }

    if line.chars().nth(index).unwrap() == 's' {
        if get_substring(line, index, "six".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "six"
        {
            *number = 6;
        }

        if get_substring(line, index, "seven".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "seven"
        {
            *number = 7;
        }
    }

    if line.chars().nth(index).unwrap() == 'e' {
        if get_substring(line, index, "eight".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "eight"
        {
            *number = 8;
        }
    }

    if line.chars().nth(index).unwrap() == 'n' {
        if get_substring(line, index, "nine".len())
            .map(|s| s.to_string())
            .unwrap_or_default()
            == "nine"
        {
            *number = 9;
        }
    }
}

fn main() {
    let lines = lines_from_file("input_part2.in").expect("Could not load lines");
    let mut sum = 0;

    for line in lines {
        let mut left_number: i32 = -1;
        let mut right_number: i32 = -1;

        for index in 0..line.len() {
            let temp_left_number = line.chars().nth(index).unwrap();
            let temp_right_number = line.chars().nth(line.len() - index - 1).unwrap();

            if left_number == -1 {
                check_string_number(&line, &mut left_number, index);
            }

            if right_number == -1 {
                check_string_number(&line, &mut right_number, line.len() - index - 1);
            }

            if left_number == -1 && temp_left_number.is_digit(10) {
                left_number = temp_left_number.to_digit(10).unwrap() as i32;
            }

            if right_number == -1 && temp_right_number.is_digit(10) {
                right_number = temp_right_number.to_digit(10).unwrap() as i32;
            }

            if left_number != -1 && right_number != -1 {
                break;
            }
        }

        sum += left_number * 10 + right_number;
    }

    println!("{}", sum.to_string());
}
