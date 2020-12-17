require "set"

if ARGV.length < 1
  input_path = "input/17.txt"
else
  input_path = "sample/17.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

def add_border!(arr)
  (0...arr.size).each do |i|
    arr[i].push(".")
    arr[i].unshift(".")
  end
  arr.push(("." * (arr[0].size)).chars)
  arr.unshift(("." * (arr[0].size)).chars)
  arr
end

state = [[]]
input.each_with_index do |line, i|
  state[0].push(line.chars)
end
add_border!(state[0])

def deep_copy3(arr)
  newarr = Array.new(arr.size) { Array.new(arr[0].size) { Array.new(arr[0][0].size) } }
  (0...arr.size).each do |i|
    (0...arr[0].size).each do |j|
      (0...arr[0][0].size).each do |k|
        newarr[i][j][k] = arr[i][j][k]
      end
    end
  end
  newarr
end

def cycle(state, x, y)
  state.push(add_border!(Array.new(y) { Array.new(x, ".") }))
  state.push(add_border!(Array.new(y) { Array.new(x, ".") }))
  state.unshift(add_border!(Array.new(y) { Array.new(x, ".") }))
  state.unshift(add_border!(Array.new(y) { Array.new(x, ".") }))
  (0...state.size).each do |i|
    add_border!(state[i])
  end
  newstate = deep_copy3(state)
  x = state[0].size - 2
  y = state[0][0].size - 2
  (1..(state.size - 2)).each do |i|
    (1..x).each do |j|
      (1..y).each do |k|
        count = 0
        (-1..1).each do |dx|
          (-1..1).each do |dy|
            (-1..1).each do |dz|
              next if dx == 0 && dy == 0 && dz == 0
              count += 1 if state[i + dx][j + dy][k + dz] == "#"
            end
          end
        end
        if state[i][j][k] == "#"
          newstate[i][j][k] = "." unless count == 2 || count == 3
        else
          newstate[i][j][k] = "#" if count == 3
        end
      end
    end
  end

  newstate
end

def print_state(state)
  (1..state.size - 2).each do |i|
    (1..state[i].size - 2).each do |j|
      p state[i][j]
    end
    p " ///// "
  end
end

(0...6).each do |i|
  # print_state state
  # p "-----"
  state = cycle(state, state[0].size - 2, state[0][0].size - 2)
end

p state.flatten.count { |c| c == "#" }
