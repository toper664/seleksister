open System
open System.IO

type Point = { X: float; Y: float }

let zeros n =
    Array.zeroCreate n

let denom i points =
    let x = (points: Point []).[i].X
    let mutable p = 1.0
    for j = Array.length points - 1 downto 0 do
        if i <> j then
            p <- p * (x - points.[j].X)
    p

let interpolate i points =
    let length = Array.length points
    let coeff = zeros length
    coeff.[0] <- 1.0 / denom i points

    for k = 0 to Array.length points - 1 do
        if k <> i then
            let newCoeffArray = zeros length
            for j = (if k < i then k + 1 else k) downto 0 do
                if j < 2 then
                    newCoeffArray.[j + 1] <- newCoeffArray.[j + 1] + coeff.[j]
                    newCoeffArray.[j] <- newCoeffArray.[j] - points.[k].X * coeff.[j]
                    //printf "%d " k
                    //printfn "%d" j
                    //printf "%.2f " newCoeffArray.[0]
                    //printf "%.2f " newCoeffArray.[1]
                    //printfn "%.2f" newCoeffArray.[2]
            for i = 0 to Array.length points - 1 do
                coeff.[i] <- newCoeffArray.[i]
            coeff
        else
            coeff

    coeff

let lagrange points =
    let length = Array.length points
    let polynom = zeros length

    let rec loop i =
        if i < length then
            let coeff = interpolate i points
            for k = 0 to length - 1 do
                polynom.[length - 1 - k] <- polynom.[length - 1 - k] + points.[i].Y * coeff.[k]
            loop (i + 1)
    
    loop 0
    polynom

let main() =
    let lines = File.ReadAllLines("ingput.txt")
    let degree = int lines.[0]
    let points = Array.init (degree + 1) (fun i ->
        let info = lines.[i + 1].Split()
        let x = Double.Parse info.[0]
        let y = Double.Parse info.[1]
        { X = x; Y = y })

    let finalCoeff = lagrange points
    use writer = File.CreateText("otput.txt")
    finalCoeff |> Array.iter (fun coeff -> writer.Write("{0} ", coeff))
    //for i = 0 to finalCoeff.Length-1 do  
        //printfn "%.2f" finalCoeff.[i]
    printfn "Lagrange coefficients successfully written."

main()
