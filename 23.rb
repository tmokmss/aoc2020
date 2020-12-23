require "set"

if ARGV.length < 1
  input_path = "input/23.txt"
else
  input_path = "sample/23.txt"
end

puts "Load input from #{input_path}"

cups = File.read(input_path).strip.chars.map(&:to_i)
p cups

HIGHEST = cups.max
LOWEST = cups.min
N = cups.size

def move(cups, current)
  picked = (1..3).map do |_|
    idx = (current + 1) % cups.size
    if idx < current
      current -= 1
    end
    cups.delete_at(idx)
  end

  p picked

  dest = cups[current] - 1
  dest_index = 0
  loop do
    idx = cups.index(dest)
    if idx.nil?
      dest -= 1
      dest = HIGHEST if dest < LOWEST
    else
      dest_index = idx
      break
    end
  end

  insert_index = (dest_index + 1) % cups.size
  if insert_index <= current
    current += picked.size
  end

  picked.each_with_index do |p, i|
    cups.insert(insert_index + i, p)
  end

  [cups, (current + 1) % N]
end

current = 0
100.times do |i|
  cups, current = move(cups, current)
  p [i, cups, current, cups[current]]
end

idx1 = cups.find_index(1)
p (1...N).map { |i| cups[(idx1 + i) % N] }.join
