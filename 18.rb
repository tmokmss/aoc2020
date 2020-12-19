require "set"

if ARGV.length < 1
  input_path = "input/18.txt"
else
  input_path = "sample/18.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

def search_paren(line)
  pair = {}
  stack = []
  line.chars.each_with_index do |c, i|
    case c
    when "("
      stack.push(i)
    when ")"
      pair[stack.pop] = i
    end
  end
  pair
end

def eval(line)
  # p line
  line = line + "\n"
  paren = search_paren(line)
  num = -1
  left = 0
  op = ""
  i = 0
  while i < line.size
    c = line[i]
    # p [c, left, op, num]
    case c
    when "0".."9"
      num = c.to_i
    when "+", "*"
      op = c
    when "("
      num = eval(line[i + 1..paren[i] - 1])
      i = paren[i]
    when " ", ")", "\n"
      if op.empty?
        left = num
        num = -1
      end
      if !(op.empty?) && num != -1
        # p "apply #{[left, op, num]}"
        left = left.send(op, num)
        num = -1
        op = ""
      end
    end
    i += 1
  end
  left
end

def search_paren2(line)
  pair = {}
  rpair = {}
  stack = []
  line.chars.each_with_index do |c, i|
    case c
    when "("
      stack.push(i)
    when ")"
      j = stack.pop
      pair[j] = i
      rpair[i] = j
    end
  end
  [pair, rpair]
end

def preprocess2(line)
  paren, rparen = search_paren2(line)
  add = {}
  line.chars.each_with_index do |c, i|
    next if c != "+"
    if line[i - 2] == ")"
      add[rparen[i - 2]] = "("
    else
      add[i - 2] = "("
    end

    if line[i + 2] == "("
      add[paren[i + 2] + 1] = ")"
    else
      add[i + 3] = ")"
    end
  end

  cnt = 0
  res = line
  add.keys.sort.each do |k|
    res.insert(k + cnt, add[k])
    cnt += 1
  end

  res
end

p input.map { |line| eval(line) }.sum
p input.map { |line| eval(preprocess2(line)) }.sum
