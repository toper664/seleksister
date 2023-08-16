program LInterpolation;

type
  Point = record
    x, y: Double;
  end;

  DoubleArray = array of Double;
  PointArray = array of Point;

function Zeros(n: Integer): DoubleArray;
var
  i: Integer;
  Result: DoubleArray;
begin
  SetLength(Result, n);
  for i := 0 to n - 1 do
    Result[i] := 0;
  Zeros := Result;
end;

function Denom(i: Integer; const points: PointArray): Double;
var
  p, x: Double;
  j: Integer;
begin
  p := 1;
  x := points[i].x;
  for j := 0 to High(points) do
  begin
    if i <> j then
      p := p * (x - points[j].x);
  end;
  Denom := p;
end;

function Interpolate(i: Integer; const points: PointArray): DoubleArray;
var
  coeff, newCoeff: DoubleArray;
  k, j: Integer;
begin
  SetLength(coeff, Length(points));
  coeff := Zeros(Length(points));
  coeff[0] := 1 / Denom(i, points);

  for k := 0 to High(points) do
  begin
    if k <> i then
    begin
      SetLength(newCoeff, Length(points));
      newCoeff := Zeros(Length(points));
      for j := k downto 0 do
      begin
        if j < 2 then
        begin
          newCoeff[j + 1] := newCoeff[j + 1] + coeff[j];
          newCoeff[j] := newCoeff[j] - points[k].x * coeff[j];
        end;
      end;
      coeff := newCoeff;
    end;
  end;

  Interpolate := coeff;
end;

function Lagrange(const points: PointArray): DoubleArray;
var
  polynom, coeff: DoubleArray;
  i, k: Integer;
begin
  SetLength(polynom, Length(points));
  polynom := Zeros(Length(points));
  SetLength(coeff, Length(points));

  for i := 0 to High(points) do
  begin
    coeff := Interpolate(i, points);
    for k := 0 to High(points) do
    begin
      polynom[Length(points) - 1 - k] := polynom[Length(points) - 1 - k] + points[i].y * coeff[k];
    end;
  end;

  Lagrange := polynom;
end;

var
  points: PointArray;
  input: TextFile;
  output: TextFile;
  degree, i: Integer;
  x, y: Double;
  finalCoeff: DoubleArray;
begin
  Assign(input, 'ingput.txt');
  Reset(input);
  ReadLn(input, degree);
  degree := degree + 1;
  
  for i := 0 to degree - 1 do
  begin
    ReadLn(input, x, y);
    SetLength(points, Length(points) + 1);
    points[i].x := x;
    points[i].y := y;
  end;
  Close(input);

  finalCoeff := Lagrange(points);

  Assign(output, 'otput.txt');
  Rewrite(output);
  for i := 0 to High(finalCoeff) do
  begin
    Write(output, finalCoeff[i]:0:2, ' ');
  end;
  Close(output);

  WriteLn('Lagrange coefficients successfully written.');
end.
