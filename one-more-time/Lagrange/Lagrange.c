#include <stdio.h>
#include <stdlib.h>

typedef struct {
    double x, y;
} Point;

double* zeros(int n) {
    double* arr = (double*)malloc(n * sizeof(double));
    for (int i = 0; i < n; i++) {
        arr[i] = 0;
    }
    return arr;
}

double denom(int i, Point* points, int length) {
    double p = 1;
    double x = points[i].x;
    for (int j = 0; j < length; j++) {
        if (i != j) {
            p *= x - points[j].x;
        }
    }
    return p;
}

double* interpolate(int i, Point* points, int length) {
    double* coeff = zeros(length);
    coeff[0] = 1.0 / denom(i, points, length);

    for (int k = 0; k < length; k++) {
        if (k == i) {
            continue;
        }
        double* newCoeff = zeros(length);
        for (int j = (k < i) ? k + 1 : k; j >= 0; j--) {
            if (j < 2) {
                newCoeff[j + 1] += coeff[j];
                newCoeff[j] -= points[k].x * coeff[j];
            }
        }
        free(coeff);
        coeff = newCoeff;
    }
    return coeff;
}

double* lagrange(Point* points, int length) {
    double* polynom = zeros(length);
    double* coeff;

    for (int i = 0; i < length; i++) {
        coeff = interpolate(i, points, length);
        for (int k = 0; k < length; k++) {
            polynom[length - 1 - k] += points[i].y * coeff[k];
        }
        free(coeff);
    }
    return polynom;
}

int main() {
    FILE* inputFile = fopen("ingput.txt", "r");
    int degree;
    fscanf(inputFile, "%d", &degree);

    Point* points = (Point*)malloc((degree + 1) * sizeof(Point));
    for (int i = 0; i < degree + 1; i++) {
        double x, y;
        fscanf(inputFile, "%lf %lf", &x, &y);
        points[i].x = x;
        points[i].y = y;
    }
    fclose(inputFile);

    double* finalCoeff = lagrange(points, degree + 1);
    FILE* outputFile = fopen("otput.txt", "w");
    for (int i = 0; i < degree + 1; i++) {
        fprintf(outputFile, "%lf ", finalCoeff[i]);
    }
    fclose(outputFile);
    free(finalCoeff);
    free(points);

    printf("Lagrange coefficients successfully written.\n");

    return 0;
}
