use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader};

fn interpolate(d: usize, x: &Vec<f64>, y: &Vec<f64>) -> Vec<f64> {
    let mut p = vec![0.0; d];

    for i in 0..d {
        let mut product = 1.0;
        let mut t = vec![0.0; d];

        for j in 0..d {
            if i == j {
                continue;
            }
            product *= x[i] - x[j];
        }

        product = y[i] / product;
        t[0] = product;

        for j in 0..d {
            if i == j {
                continue;
            }
            for k in (1..d).rev() {
                t[k] += t[k - 1];
                t[k - 1] *= -x[j];
            }
        }

        for j in 0..d {
            p[j] += t[j];
        }
    }

    p
}

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Error: Please provide a file path.");
        return Ok(());
    }

    let path = &args[1];
    let file = File::open(path)?;
    let reader = BufReader::new(file);

    let mut x = Vec::new();
    let mut y = Vec::new();

    for line in reader.lines() {
        let line = line?;
        let split: Vec<&str> = line.split_whitespace().collect();
        if split.len() != 2 {
            eprintln!("Error: Invalid input format");
            return Ok(());
        }

        let x_val: f64 = split[0].parse().expect("Failed to parse x value");
        let y_val: f64 = split[1].parse().expect("Failed to parse y value");

        x.push(x_val);
        y.push(y_val);
    }

    let p = interpolate(x.len(), &x, &y);
    for val in p {
        print!("{} ", val);
    }
    println!();

    Ok(())
}
