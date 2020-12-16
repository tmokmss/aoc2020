require "set"

if ARGV.length < 1
  input_path = "input/16.txt"
else
  input_path = "sample/16.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

words = {}
mine = []
nearby = []
mode = 0
input.each_with_index do |line, i|
  next if line.empty?

  if line == "nearby tickets:"
    mode = 2
    next
  elsif line == "your ticket:"
    mode = 1
    next
  end
  case mode
  when 0
    m = /(.*)\: (\d+)\-(\d+) or (\d+)\-(\d+)/.match(line)
    words[m[1]] = [[m[2].to_i, m[3].to_i], [m[4].to_i, m[5].to_i]]
  when 1
    mine = line.split(",").map(&:to_i)
  when 2
    nearby.push(line.split(",").map(&:to_i))
  end
end

valid = {}
words.each do |word, val|
  val.each do |v|
    (v[0]..v[1]).each do |i|
      valid[i] = Set.new unless valid.has_key?(i)
      valid[i].add(word)
    end
  end
end

ans = 0
nearby.each do |t|
  t.each do |i|
    ans += i unless valid.has_key?(i)
  end
end

p ans

valid_tickets = nearby.select do |t|
  t.all? do |i|
    valid.has_key?(i)
  end
end

candidates = []
# p valid
(0...valid_tickets.first.size).each do |i|
  cand = valid[valid_tickets.first[i]]
  valid_tickets[1..].each do |t|
    cand = cand & valid[t[i]]
    break if cand.size == 1
  end
  candidates.push(cand)
end

ans = Array.new(candidates.size)
used = Set.new
loop do
  candidates.each_with_index do |cand, i|
    cand = cand - used
    if cand.size == 1
      ans[i] = cand.first
      used.add(cand.first)
    end
  end
  break if used.size == ans.size
end

p ans
mul = 1
ans.each_with_index do |a, i|
  mul *= (mine[i]) if a.start_with?("departure")
  p [a, i, mine[i]]
end

p mul
