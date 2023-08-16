import Foundation
import Glibc

struct Point {
    var x, y: Double
}

func zeros(_ n: Int) -> UnsafeMutablePointer<Double> {
    let arr = UnsafeMutablePointer<Double>.allocate(capacity: n)
    for i in 0..<n {
        arr[i] = 0
    }
    return arr
}

func denom(_ i: Int, _ points: UnsafeMutablePointer<Point>, _ length: Int) -> Double {
    var p = 1.0
    let x = points[i].x
    for j in 0..<length {
        if i != j {
            p *= x - points[j].x
        }
    }
    return p
}

func interpolate(_ i: Int, _ points: UnsafeMutablePointer<Point>, _ length: Int) -> UnsafeMutablePointer<Double> {
    var coeff = zeros(length)
    coeff[0] = 1.0 / denom(i, points, length)

    for k in 0..<length {
        if k == i {
            continue
        }
        let newCoeff = zeros(length)
        for j in ((k < i) ? k + 1 : k)...0 {
            if j < 2 {
                newCoeff[j + 1] += coeff[j]
                newCoeff[j] -= points[k].x * coeff[j]
            }
        }
        coeff.deallocate()
        coeff = newCoeff
    }
    return coeff
}

func lagrange(_ points: UnsafeMutablePointer<Point>, _ length: Int) -> UnsafeMutablePointer<Double> {
    let polynom = zeros(length)
    var coeff: UnsafeMutablePointer<Double>?

    for i in 0..<length {
        coeff = interpolate(i, points, length)
        for k in 0..<length {
            polynom[length - 1 - k] += points[i].y * coeff![k]
        }
        coeff?.deallocate()
    }
    return polynom
}

func main() {
    let fileManager = FileManager.default
    let inputFilePath = "ingput.txt"
    let outputFilePath = "otput.txt"
    
    if !fileManager.fileExists(atPath: inputFilePath) {
        print("Input file not found.")
        return
    }
    
    guard let inputFile = fopen(inputFilePath, "r") else {
        print("Unable to open input file.")
        return
    }
    defer { fclose(inputFile) }
    
    var degree: Int32
    fscanf(inputFile, "%d", &degree)
    
    let points = UnsafeMutablePointer<Point>.allocate(capacity: Int(degree + 1))
    for i in 0..<Int(degree + 1) {
        var x, y: Double
        fscanf(inputFile, "%lf %lf", &x, &y)
        points[i] = Point(x: x, y: y)
    }
    
    let finalCoeff = lagrange(points, Int(degree + 1))
    
    guard let outputFile = fopen(outputFilePath, "w") else {
        print("Unable to open output file.")
        return
    }
    defer { fclose(outputFile) }
    
    for i in 0..<Int(degree + 1) {
        fprintf(outputFile, "%.0f ", finalCoeff[i])
    }
    
    finalCoeff.deallocate()
    points.deallocate()
    
    print("Lagrange coefficients successfully written.")
}

main()
