#python 3.x
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

def zeros(n):
    return [0] * n

def denom(i, points):
    p = 1
    x = points[i].x
    for j in range(len(points)):
        if i != j:
            p *= x - points[j].x
    return p

def interpolate(i, points):
    coeff = zeros(len(points))
    coeff[0] = 1 / denom(i, points)

    for k in range(len(points)):
        if k == i:
            continue
        new_coeff = zeros(len(points))
        for j in range(k + 1 if k < i else k, -1, -1):
            if j < 2:
                new_coeff[j + 1] += coeff[j]
                new_coeff[j] -= points[k].x * coeff[j]
        coeff = new_coeff
    return coeff

def lagrange(points):
    polynom = zeros(len(points))
    for i in range(len(points)):
        coeff = interpolate(i, points)
        for k in range(len(points)):
            polynom[len(points) - 1 - k] += points[i].y * coeff[k]
    return polynom

if __name__ == "__main__":
    points = []
    with open("ingput.txt", "r") as input:
        degree = int(input.readline())
        for _ in range(degree + 1):
            x, y = map(float, input.readline().split())
            points.append(Point(x, y))

    final_coeff = lagrange(points)
    with open("otput.txt", "w") as output:
        output.write(" ".join(map(str, final_coeff)))

    print("Lagrange coefficients successfully written.")
