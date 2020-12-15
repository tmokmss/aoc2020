require "set"

if ARGV.length < 1
  input_path = "input/15.txt"
else
  input_path = "sample/15.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).strip.split(",").map(&:to_i)

before = {}

input.each_with_index do |a, i|
  before[a] = [i]
end

last = input.last

(input.size...30000000).each do |i|
  if before.has_key?(last)
    bs = before[last]
    last = bs[bs.size - 1] - bs[bs.size - 2]
  else
    before[0].push(i)
    last = 0
  end
  before[last] = [] unless before.has_key?(last)
  before[last].push(i)
  # p [last, i]
end

# p before
puts(last)
