package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func interpolate(d int, x []float64, y []float64) []float64 {
	p := make([]float64, d)

	for i := 0; i < d; i++ {
		product := 1.0
		t := make([]float64, d)

		for j := 0; j < d; j++ {
			if i == j {
				continue
			}
			product *= (x[i] - x[j])
		}

		product = y[i] / product
		t[0] = product

		for j := 0; j < d; j++ {
			if i == j {
				continue
			}
			for k := d - 1; k > 0; k-- {
				t[k] += t[k-1]
				t[k-1] *= (-x[j])
			}
		}

		for j := 0; j < d; j++ {
			p[j] += t[j]
		}
	}

	return p
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Error: Please provide a file path.")
		return
	}

	path := os.Args[1]
	file, err := os.Open(path)
	if err != nil {
		fmt.Printf("Error: The file at '%s' doesn't exist!\n", path)
		return
	}
	defer file.Close()

	var x, y []float64
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		split := strings.Split(line, " ")

		if len(split) != 2 {
			fmt.Println("Error: Invalid input format")
			return
		}

		xVal, err1 := strconv.ParseFloat(split[0], 64)
		yVal, err2 := strconv.ParseFloat(split[1], 64)
		if err1 != nil || err2 != nil {
			fmt.Println("Error: Invalid number format in the file")
			return
		}

		x = append(x, xVal)
		y = append(y, yVal)
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading the file.")
		return
	}

	p := interpolate(len(x), x, y)
	for _, val := range p {
		fmt.Print(val, " ")
	}
	fmt.Println()
}
