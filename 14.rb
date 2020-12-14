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
  masked = []
  mask.chars.reverse.each_with_index do |c, i|
    masked.push(c)
    if c == "X"
      if i < val2.size
        masked[i] = val2[i]
      else
        masked[i] = "0"
      end
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
  masked = []
  mask.chars.reverse.each_with_index do |c, i|
    masked.push(c)
    if c == "0"
      if i < val2.size
        masked[i] = val2[i]
      else
        masked[i] = "0"
      end
    end
  end

  masked.reverse.join("")
end

def search_char(str, char)
  res = []
  str.chars.each_with_index do |c, i|
    res.push(i) if c == char
  end
  res
end

def list_all_possible_values(val2)
  # val2 is string like 000000000000000000000000000000X1101X
  xpos = search_char(val2, "X")
  # puts val2
  # puts "xpos #{xpos}"
  xnum = xpos.size
  (0...2 ** xnum).map do |k|
    val2m = val2
    tmp = k
    (0...xnum).each do |i|
      if tmp % 2 == 1
        val2m[xpos[i]] = "1"
      else
        val2m[xpos[i]] = "0"
      end
      tmp /= 2
    end
    # puts val2m
    val2m.to_i(2)
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
# # puts search_char("000000000000000000000000000000X1001X", "X")
# aa= apply_mask2("000000000000000000000000000000X1001X", 42)
# puts list_all_possible_values(aa)
