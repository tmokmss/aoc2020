require "set"

if ARGV.length < 1
  input_path = "input/21.txt"
else
  input_path = "sample/21.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)
foods = input.map do |line|
  match = /(.*)\(contains (.*)\)/.match(line)
  [Set.new(match[1].split), match[2].gsub(" ", "").split(",")]
end

allergen_candidates = {}

foods.each do |food|
  alle = food[1]
  alle.each do |a|
    unless allergen_candidates.has_key?(a)
      allergen_candidates[a] = food[0]
    end
    allergen_candidates[a] &= food[0]
  end
end

all_ingredients = Set.new
ingredient_count = Hash.new { |h, k| h[k] = 0 }
foods.each do |food|
  food[0].each do |ing|
    all_ingredients.add(ing)
    ingredient_count[ing] += 1
  end
end

candidate = all_ingredients - allergen_candidates.values.inject(&:+)
ans = candidate.map { |c| ingredient_count[c] }.sum

p ans

allergens = {}
used = Set.new

loop do
  allergen_candidates.each do |allergen, words|
    words = words - used
    if words.size == 1
      allergens[allergen] = words.first
      used.add(words.first)
    end
  end
  break if allergens.size == allergen_candidates.size
end

sorted = allergens.map { |k, v| k }.sort
p sorted.map { |w| allergens[w] }.join(",")
