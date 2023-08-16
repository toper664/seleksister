#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>

struct Point {
    double x, y;

    Point(double x, double y) : x(x), y(y) {}
};

std::vector<double> zeros(int n) {
    std::vector<double> arr(n, 0);
    return arr;
}

double denom(int i, const std::vector<Point>& points) {
    double p = 1;
    double x = points[i].x;
    for (int j = 0; j < points.size(); j++) {
        if (i != j) {
            p *= x - points[j].x;
        }
    }
    return p;
}

std::vector<double> interpolate(int i, const std::vector<Point>& points) {
    std::vector<double> coeff = zeros(points.size());
    coeff[0] = 1 / denom(i, points);

    for (int k = 0; k < points.size(); k++) {
        if (k == i) {
            continue;
        }
        std::vector<double> newCoeff = zeros(points.size());
        for (int j = (k < i) ? k + 1 : k; j >= 0; j--) {
            if (j < 2) {
                newCoeff[j + 1] += coeff[j];
                newCoeff[j] -= points[k].x * coeff[j];
            }
        }
        coeff = newCoeff;
    }
    return coeff;
}

std::vector<double> lagrange(const std::vector<Point>& points) {
    std::vector<double> polynom = zeros(points.size());
    std::vector<double> coeff;

    for (int i = 0; i < points.size(); i++) {
        coeff = interpolate(i, points);
        for (int k = 0; k < points.size(); k++) {
            polynom[points.size() - 1 - k] += points[i].y * coeff[k];
        }
    }
    return polynom;
}

int main() {
    std::vector<Point> points;
    std::ifstream input("ingput.txt");
    int degree;
    input >> degree;

    for (int i = 0; i < degree + 1; i++) {
        double x, y;
        input >> x >> y;
        points.push_back(Point(x, y));
    }
    input.close();

    std::vector<double> final = lagrange(points);
    std::ofstream output("otput.txt");
    for (double coeff : final) {
        output << coeff << " ";
    }
    output.close();

    std::cout << "Lagrange coefficients successfully written." << std::endl;

    return 0;
}
