require "set"

if ARGV.length < 1
  input_path = "input/12.txt"
else
  input_path = "sample/12.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

n = input.size
ans = 0

rot = 0
curdir = [1, 0]
curx = 0
cury = 0

def rot90(curr, reverse)
  coeff = reverse ? -1 : 1
  [-curr[1] * coeff, curr[0] * coeff]
end

DIRECTION = {
  "N" => [0, 1],
  "S" => [0, -1],
  "E" => [1, 0],
  "W" => [-1, 0],
}

input.each do |line|
  dir = line[0]
  num = line[1..].to_i
  case dir
  when "N", "S", "E", "W"
    d = DIRECTION[dir]
    curx += d[0] * num
    cury += d[1] * num
  when "L", "R"
    cnt = num / 90
    (0...cnt).each do |_|
      curdir = rot90(curdir, dir == "R")
    end
  when "F"
    curx += curdir[0] * num
    cury += curdir[1] * num
  end

  # puts "#{dir} #{num}, #{newdir} #{curx},#{cury},#{curdir}"
end

puts (curx.abs + cury.abs)
wp = [10, 1]
curr = [0, 0]

input.each do |line|
  dir = line[0]
  num = line[1..].to_i
  case dir
  when "N", "S", "E", "W"
    d = DIRECTION[dir]
    wp[0] += d[0] * num
    wp[1] += d[1] * num
  when "L", "R"
    cnt = num / 90
    (0...cnt).each do |_|
      wp = rot90(wp, dir == "R")
    end
  when "F"
    (0...num).each do |_|
      curr[0] += wp[0]
      curr[1] += wp[1]
    end
  end

  # puts "#{dir} #{num}, #{curr} #{wp}"
end

puts (curr[0].abs + curr[1].abs)
