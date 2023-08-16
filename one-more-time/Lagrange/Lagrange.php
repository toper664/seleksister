<?php

class Point {
    public $x;
    public $y;

    function __construct($x, $y) {
        $this->x = $x;
        $this->y = $y;
    }
}

function zeros($n) {
    $arr = array();
    for ($i = 0; $i < $n; $i++) {
        $arr[$i] = 0;
    }
    return $arr;
}

function denom($i, $points) {
    $p = 1;
    $x = $points[$i]->x;
    for ($j = 0; $j < count($points); $j++) {
        if ($i != $j) {
            $p *= $x - $points[$j]->x;
        }
    }
    return $p;
}

function interpolate($i, $points) {
    $coeff = zeros(count($points));
    $coeff[0] = 1 / denom($i, $points);

    for ($k = 0; $k < count($points); $k++) {
        if ($k != $i) {
            $newCoeff = zeros(count($points));
            for ($j = ($k < $i) ? $k + 1 : $k; $j >= 0; $j--) {
                if ($j < 2) {
                    $newCoeff[$j + 1] += $coeff[$j];
                    $newCoeff[$j] -= $points[$k]->x * $coeff[$j];
                }
            }
            $coeff = $newCoeff;
        }
    }

    return $coeff;
}

function lagrange($points) {
    $polynom = zeros(count($points));
    $coeff = array();

    for ($i = 0; $i < count($points); $i++) {
        $coeff = interpolate($i, $points);
        for ($k = 0; $k < count($points); $k++) {
            $polynom[count($points) - 1 - $k] += $points[$i]->y * $coeff[$k];
        }
    }

    return $polynom;
}

$points = array();
$lines = file('ingput.txt', FILE_IGNORE_NEW_LINES);
$degree = (int) $lines[0] + 1;

for ($e = 1; $e <= $degree; $e++) {
    $values = explode(' ', $lines[$e]);
    $points[] = new Point((double)$values[0], (double)$values[1]);
}

$finalCoeff = lagrange($points);
$finalString = implode(' ', array_map(function ($c) {
    return sprintf('%.2f', $c);
}, $finalCoeff));

file_put_contents('otput.txt', $finalString);
echo 'Lagrange coefficients successfully written.';

?>
