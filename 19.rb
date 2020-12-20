require "set"

if ARGV.length < 1
  input_path = "input/19.txt"
else
  input_path = "sample/19.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
raw_rules = {}
lines = []

input.each do |line|
  match = /(\d+)\: (.*)/.match(line)

  if match.nil?
    lines.push(line) unless line.empty?
    next
  end

  raw_rules[match[1].to_i] = match[2]
end

raw_rules[8] = "42 | 42 8"
raw_rules[11] = "42 31 | 42 11 31"

class Rule
  attr_reader :children, :parent, :is_leaf

  def initialize
    @children = []
    @parent = Set.new
    @is_leaf = false
  end

  def add_child(c)
    @children.push(c)
    @is_leaf = c == "a" || c == "b"
  end

  def add_parent(i)
    @parent.add(i)
  end
end

entry_point = []
rules = Hash.new { |hash, key| hash[key] = Rule.new }

raw_rules.each do |i, rule|
  if rule == '"a"' || rule == '"b"'
    rules[i].add_child(rule[1])
    entry_point.push(i)
    next
  end

  rs = rule.split("|")
  rs.each do |r|
    rr = r.split.map(&:to_i)
    rules[i].add_child(rr)
    rr.each do |p|
      rules[p].add_parent(i)
    end
  end
end

p lines
p rules

def match?(str, offset, nest, rule_idx, rules)
  # p [str[offset..], offset, nest, rule_idx]
  return false, [] if offset >= str.size
  return false, [] if nest > str.size #- offset
  r = rules[rule_idx]
  if r.is_leaf
    if str[offset] == r.children.first
      return true, [offset + 1]
    else
      return false, []
    end
  end

  res = Set.new
  r.children.each do |childs|
    prev_offset = Set.new([offset])
    childs.each do |child|
      next_offset = Set.new
      prev_offset.each do |ofs|
        _, offsets = match?(str, ofs, nest + 1, child, rules)
        next_offset += offsets
      end

      prev_offset = next_offset
    end
    res += prev_offset
  end

  if nest == 0
    return !res.empty? && res.any?(str.size), res
  else
    return !res.empty?, res
  end
end

# p match?("abbbab", 0, 0, 0, rules)
# p match?("bababa", 0, 0, 0, rules)
# p match?("ababbb", 0, 0, 0, rules)
# p match?("aaaabb", 0, 0, 0, rules)
# p match?("aaaabbb", 0, 0, 0, rules)
matched = lines.select do |line|
  p line
  match, res = match?(line, 0, 0, 0, rules)
  p res
  match
end

p matched
p matched.count
