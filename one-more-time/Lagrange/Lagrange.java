import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;

public class Lagrange {
    public static double[] zeros(int n) {
        double[] arr = new double[n];
        Arrays.fill(arr, 0);
        return arr;
    }

    static class Point {
        double x, y;
    
        Point(double x, double y) {
            this.x = x;
            this.y = y;
        }
    }

    public static double denom(int i, Point[] points) {
        double p = 1;
        double x = points[i].x;
        for (int j = 0; j < points.length; j++) {
            if (i != j) {
                p *= x - points[j].x;
            }
        }
        return p;
    }

    public static double[] interpolate(int i, Point[] points) {
        double[] coeff = zeros(points.length);
        coeff[0] = 1 / denom(i, points);

        for (int k = 0; k < points.length; k++) {
            if (k == i) {
                continue;
            }
            double[] newCoeff = zeros(points.length);
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

    public static double[] lagrange(Point[] points) {
        double[] polynom = zeros(points.length);
        double[] coeff;

        for (int i = 0; i < points.length; i++) {
            coeff = interpolate(i, points);
            for (int k = 0; k < points.length; k++) {
                polynom[points.length - 1 - k] += points[i].y * coeff[k];
            }
        }
        return polynom;
    }

    public static void main(String[] args) throws IOException {
        Point[] points = null;
        try (BufferedReader br = new BufferedReader(new FileReader("ingput.txt"))) {
            int degree = Integer.parseInt(br.readLine());
            points = new Point[degree + 1];
            for (int i = 0; i < degree + 1; i++) {
                String[] info = br.readLine().split(" ");
                double x = Double.parseDouble(info[0]);
                double y = Double.parseDouble(info[1]);
                points[i] = new Point(x, y);
            }
        }

        double[] finalCoeff = lagrange(points);
        StringBuilder str = new StringBuilder();
        for (double coeff : finalCoeff) {
            str.append(coeff).append(" ");
        }

        try (FileWriter writer = new FileWriter("otput.txt")) {
            writer.write(str.toString());
            System.out.println("Lagrange coefficients successfully written.");
        }
    }
}
