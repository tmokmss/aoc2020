require "set"

if ARGV.length < 1
  input_path = "input/23.txt"
else
  input_path = "sample/23.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).strip.chars.map(&:to_i)
N = 1000000

def print(arr)
  curr = 1
  temp = (0...arr.size - 1).map do |i|
    curr = arr[curr]
  end
  temp.join(",")
end

def move(cups, current)
  picked = (1..3).map do |_|
    idx = cups[current]
    next_idx = cups[idx]
    cups[current] = next_idx
    cups[idx] = nil
    idx
  end

  # p [picked, cups]

  dest = current - 1
  dest_index = 0
  loop do
    if cups[dest].nil?
      dest -= 1
      dest = N if dest < 1
    else
      break
    end
  end

  picked.reverse.each do |p|
    next_dest = cups[dest]
    cups[dest] = p
    cups[p] = next_dest
  end

  cups[current]
end

cups = Array.new(N + 1) # cup#index's next is cup#value
(0...input.size - 1).each do |i|
  cups[input[i]] = input[i + 1]
end
cups[input[-1]] = input.size + 1

(input.size + 1...N).each do |i|
  cups[i] = i + 1
end
cups[N] = input[0]
# cups[input[-1]] = input[0]

# p cups
# p print(cups)
current = input[0]

(N * 10).times do |i|
  current = move(cups, current)
  # p [i, print(cups), current]
end

next1 = cups[1]
next2 = cups[next1]
p next2 * next1
# p (1...N).map { |i| cups[(idx1 + i) % N] }.join
