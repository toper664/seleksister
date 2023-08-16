using System;
using System.Collections.Generic;
using System.IO;

public class Point
{
    public double x, y;

    public Point(double x, double y)
    {
        this.x = x;
        this.y = y;
    }
}

public class Lagrange
{
    public static List<double> Zeros(int n)
    {
        List<double> arr = new List<double>();
        for (int i = 0; i < n; i++)
        {
            arr.Add(0);
        }
        return arr;
    }

    public static double Denom(int i, List<Point> points)
    {
        double p = 1;
        double x = points[i].x;
        for (int j = 0; j < points.Count; j++)
        {
            if (i != j)
            {
                p *= x - points[j].x;
            }
        }
        return p;
    }

    public static List<double> Interpolate(int i, List<Point> points)
    {
        List<double> coeff = Zeros(points.Count);
        coeff[0] = 1 / Denom(i, points);

        for (int k = 0; k < points.Count; k++)
        {
            if (k == i)
            {
                continue;
            }
            List<double> newCoeff = Zeros(points.Count);
            for (int j = (k < i) ? k + 1 : k; j >= 0; j--)
            {
                if (j < 2)
                {
                    newCoeff[j + 1] += coeff[j];
                    newCoeff[j] -= points[k].x * coeff[j];
                }
            }
            coeff = newCoeff;
        }
        return coeff;
    }

    public static List<double> Lagrange(List<Point> points)
    {
        List<double> polynom = Zeros(points.Count);
        List<double> coeff;

        for (int i = 0; i < points.Count; i++)
        {
            coeff = Interpolate(i, points);
            for (int k = 0; k < points.Count; k++)
            {
                polynom[points.Count - 1 - k] += points[i].y * coeff[k];
            }
        }
        return polynom;
    }

    public static void Main(string[] args)
    {
        List<Point> points = new List<Point>();
        using (StreamReader input = new StreamReader("ingput.txt"))
        {
            int degree = int.Parse(input.ReadLine());
            for (int i = 0; i < degree + 1; i++)
            {
                string[] info = input.ReadLine().Split();
                double x = double.Parse(info[0]);
                double y = double.Parse(info[1]);
                points.Add(new Point(x, y));
            }
        }

        List<double> final = Lagrange(points);
        using (StreamWriter output = new StreamWriter("otput.txt"))
        {
            foreach (double coeff in final)
            {
                output.Write(coeff + " ");
            }
        }

        Console.WriteLine("Lagrange coefficients successfully written.");
    }
}
