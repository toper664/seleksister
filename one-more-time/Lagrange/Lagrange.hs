import Text.Printf
import System.IO

data Point = Point { x :: Double, y :: Double }

zeros :: Int -> [Double]
zeros n = replicate n 0.0

denom :: Int -> [Point] -> Double
denom i points = foldl (\p j -> if i /= j then p * (x (points !! i) - x (points !! j)) else p) 1.0 [0..length points - 1]

interpolate :: Int -> [Point] -> [Double]
interpolate i points = let
    coeff = zeros (length points)
    coeff' = 1 / denom i points : map (\k -> if k == i then 0.0 else 1 / denom i points) [0..length points - 1]
    newCoeff = foldl (\newCoeff k -> if k /= i then
        let
            x' = x (points !! k)
            newCoeff' = zipWith (\j c -> if j < 2 then c + newCoeff !! j else c) [0..length newCoeff - 1] newCoeff
            newCoeff'' = zipWith (\j c -> if j < 2 then c - x' * newCoeff !! (j+1) else c) [0..length newCoeff - 1] newCoeff
        in newCoeff' else newCoeff) coeff' [0..length points - 1]
    in newCoeff

lagrange :: [Point] -> [Double]
lagrange points = let
    polynom = zeros (length points)
    coeff = zeros (length points)
    coeff' = interpolate 0 points
    polynom' = foldl (\polynom i -> let
        coeff'' = interpolate i points
        polynom'' = zipWith (\k c -> c + y (points !! i) * coeff !! k) [0..length coeff - 1] polynom
        in polynom'') polynom [0..length points - 1]
    in polynom'

main :: IO ()
main = do
    contents <- readFile "ingput.txt"
    let nums = map read $ words contents
    let degree = head nums + 1
    let pointPairs = chunksOf 2 $ tail nums
    let points = map (\[x, y] -> Point x y) pointPairs
    let finalCoeff = lagrange points
    writeFile "otput.txt" $ unwords $ map (formatDouble 2) finalCoeff
    putStrLn "Lagrange coefficients successfully written."

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : chunksOf n (drop n xs)

formatDouble :: Int -> Double -> String
formatDouble n = printf ("%." ++ show n ++ "f")

