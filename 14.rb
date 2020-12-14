require "set"

if ARGV.length < 1
  input_path = "input/14.txt"
else
  input_path = "sample/14.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

def apply_mask(mask, val)
  val2 = val.to_s(2).chars.reverse
  masked = mask.chars.reverse.map.with_index do |c, i|
    next c if c != "X"
    if i < val2.size
      val2[i]
    else
      "0"
    end
  end
  # puts "#{val2} #{masked}"

  masked.reverse.join("").to_i(2)
end

mask = ""
memory = {}
input.each_with_index do |line, i|
  if line.start_with?("mask")
    mask = line.split[2]
  elsif line.start_with?("mem")
    m = /mem\[(.*)\] = (.*)/.match(line)
    p = m[1]
    val = m[2].to_i
    memory[p] = apply_mask(mask, val)
  end
end

puts(memory.values.sum)

def apply_mask2(mask, val)
  val2 = val.to_s(2).chars.reverse
  masked = mask.chars.reverse.map.with_index do |c, i|
    next c if c != "0"
    if i < val2.size
      val2[i]
    else
      "0"
    end
  end

  masked.reverse.join("")
end

def search_char(str, char)
  str.chars.filter_map.with_index do |c, i|
    i if c == char
  end
end

def list_all_possible_values(val2)
  # val2 is string like 000000000000000000000000000000X1101X
  xpos = search_char(val2, "X")
  xnum = xpos.size
  [0, 1].repeated_permutation(xnum).map do |arr|
    arr.each_with_index do |a, i|
      val2[xpos[i]] = a.to_s
    end
    val2.to_i(2)
  end
end

mask = ""
memory = {}
input.each_with_index do |line, i|
  if line.start_with?("mask")
    mask = line.split[2]
  elsif line.start_with?("mem")
    m = /mem\[(.*)\] = (.*)/.match(line)
    p = m[1].to_i
    val = m[2].to_i
    addr = apply_mask2(mask, p)
    addr_list = list_all_possible_values(addr)
    addr_list.each do |a|
      memory[a] = val
    end
  end
end

puts(memory.values.sum)
#puts apply_mask2("000000000000000000000000000000X1001X", 42)
# puts search_char("000000000000000000000000000000X1001X", "X")
# aa = apply_mask2("000000000000000000000000000000X1001X", 42)
# p list_all_possible_values(aa)
