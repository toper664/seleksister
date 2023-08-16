def interpolate(d, x, y)
  p = Array.new(d, 0.0)

  for i in 0...d
    product = 1.0
    t = Array.new(d, 0.0)

    for j in 0...d
      next if i == j
      product *= (x[i] - x[j])
    end

    product = y[i] / product
    t[0] = product

    for j in 0...d
      next if i == j
      (d - 1).downto(1) do |k|
        t[k] += t[k - 1]
        t[k - 1] *= (-x[j])
      end
    end

    for j in 0...d
      p[j] += t[j]
    end
  end

  p
end

def main
  
    path = "ingput.txt"
    unless File.exist?(path)
      puts "Error: The file at '#{path}' doesn't exist!"
      return
    end

    begin
      d = 0
      x = []
      y = []

      File.open(path, 'r') do |file|
        file.each_line do |line|
          split = line.split(" ")
          raise ValueError if split.length != 2
          x << split[0].to_f
          y << split[1].to_f
          d += 1
        end
      end

      p = interpolate(d, x, y)
      puts p.join(" ")
    rescue
      puts "Error: Invalid input format"
    end
  end
end

main