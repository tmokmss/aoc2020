require "set"

if ARGV.length < 1
  input_path = "input/13.txt"
else
  input_path = "sample/13.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

time = input[0].to_i
buses = input[1].split(",")

min = 9999999999999999
ans = 0
buses.each do |bus|
  next if bus == "x"
  bus = bus.to_i
  t = ((time + bus - 1) / bus) * bus
  if t < min
    ans = bus
    min = t
  end
end

puts ((min - time) * ans)

def mod(a, m)
  (a % m + m) % m
end

def extgcd_h(a, b, values)
  d = a

  if b.zero?
    values[:x] = 1
    values[:y] = 0
  else
    d = extgcd_h(b, a % b, values)

    x = values[:x]
    y = values[:y]
    values[:x] = y
    values[:y] = x - (a / b) * y
  end

  d
end

def chinese(b, m)
  r = 0
  mM = 1
  (0...b.size).each do |i|
    val = {}
    d = extgcd_h(mM, m[i], val)
    p = val[:x]
    q = val[:y]
    return [0, -1] if (b[i] - r) % d != 0
    tmp = (b[i] - r) / d * p % (m[i] / d)
    r += mM * tmp
    mM *= m[i] / d
  end

  [mod(r, mM), mM]
end

sum = 0
m = buses.map do |bus|
  next if bus == "x"
  bus.to_i
end.compact

b = buses.map.with_index do |bus, i|
  next if bus == "x"
  bus = bus.to_i
  bus - (i % bus)
end.compact

puts "#{m}, #{b}"
p chinese(b, m)
