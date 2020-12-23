require "set"

if ARGV.length < 1
  input_path = "input/22.txt"
else
  input_path = "sample/22.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

player = 0
decks = Hash.new { |h, k| h[k] = [] }
input.each_with_index do |line, i|
  next if line.empty?
  if line.start_with?("Player")
    player = line[7].to_i
    next
  end
  decks[player].push(line.to_i)
end

p decks

# loop do
#   p1 = decks[1].shift
#   p2 = decks[2].shift
#   if p1 > p2
#     decks[1].push(p1)
#     decks[1].push(p2)
#   else
#     decks[2].push(p2)
#     decks[2].push(p1)
#   end
#   break if decks[1].empty? || decks[2].empty?
# end

# p decks.reject { |_, v| v.empty? }.first[1].reverse.map.with_index { |m, i| m * (i + 1) }.sum

def play(deck1, deck2)
  # p [deck1, deck2]
  p1 = deck1.shift
  p2 = deck2.shift
  win = p1 > p2 ? 1 : 2
  if deck1.size >= p1 && deck2.size >= p2
    win, _, _ = game(deck1[0...p1].dup, deck2[0...p2].dup)
  end

  if win == 1
    deck1.push(p1)
    deck1.push(p2)
  else
    deck2.push(p2)
    deck2.push(p1)
  end
  return win, deck1, deck2
end

def game(deck1, deck2)
  seen1 = Set.new
  seen2 = Set.new
  loop do
    _, deck1, deck2, terminated = play(deck1, deck2)
    break if deck1.empty? || deck2.empty?

    return 1, deck1, deck2 if seen1.add?(deck1.join(",")).nil?
    return 1, deck1, deck2 if seen2.add?(deck2.join(",")).nil?
  end
  win = deck1.empty? ? 2 : 1
  return win, deck1, deck2
end

_, deck1, deck2 = game(decks[1], decks[2])
p deck1, deck2
p [deck1, deck2].reject { |v| v.empty? }.first.reverse.map.with_index { |m, i| m * (i + 1) }.sum
