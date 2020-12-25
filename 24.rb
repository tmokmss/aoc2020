require "set"

if ARGV.length < 1
  input_path = "input/24.txt"
else
  input_path = "sample/24.txt"
end

puts "Load input from #{input_path}"

# x = m, y = n*sqrt(3)
DIRECTION = {
  e: [2, 0],
  se: [1, -1],
  sw: [-1, -1],
  w: [-2, 0],
  nw: [-1, 1],
  ne: [1, 1],
}

ADJASCENT = DIRECTION.values

def parse(line, offset, result)
  str = line[offset..]
  direction = DIRECTION.keys.find { |dr| str.start_with?(dr.to_s) }
  result.push(direction)
  new_offset = offset + direction.size
  if new_offset < line.size
    parse(line, offset + direction.size, result)
  end

  result
end

input = File.read(input_path).split("\n").map(&:strip)
routes = input.map do |line|
  res = []
  parse(line, 0, res)
  res
end

panel_count = Hash.new { |h, k| h[k] = 0 }
panels = routes.map do |route|
  point = [0, 0]
  route.each do |dir|
    vec = DIRECTION[dir]
    point[0] += vec[0]
    point[1] += vec[1]
  end
  # p [route, point]

  panel_count[point] += 1
  point
end

p panel_count.select { |_, v| v % 2 == 1 }.count

panel_color = Hash.new { |h, k| h[k] = false } # true when black
panel_count.each { |h, k| panel_color[h] = k % 2 == 1 }

def add_array(arr1, arr2)
  arr1.zip(arr2).map do |a1, a2|
    a1 + a2
  end
end

def pass_day(panels)
  res = Hash.new { |h, k| h[k] = false }
  panels.keys.each do |key|
    ADJASCENT.each do |ad|
      vec = add_array(key, ad)
      panels[vec] = panels[vec]
    end
  end
  panels.keys.each do |key|
    count = 0
    ADJASCENT.each do |ad|
      vec = add_array(key, ad)
      count += 1 if panels[vec]
    end

    if panels[key]
      res[key] = !(count == 0 || count > 2)
    else
      res[key] = count == 2
    end
  end

  res
end

100.times do
  panel_color = pass_day(panel_color)
  # p panel_color
  p panel_color.select { |_, k| k }.count
end
