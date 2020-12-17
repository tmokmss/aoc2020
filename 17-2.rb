require "set"

if ARGV.length < 1
  input_path = "input/17.txt"
else
  input_path = "sample/17.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

# arr is 3 dimensional array
def add_border!(arr)
  (0...arr.size).each do |i|
    (0...arr[i].size).each do |j|
      arr[i][j].push(".")
      arr[i][j].unshift(".")
    end
    arr[i].push(("." * (arr[i][0].size)).chars)
    arr[i].unshift(("." * (arr[i][0].size)).chars)
  end
  arr.push((0...arr[0].size).map { |_| ((".") * (arr[0][0].size)).chars })
  arr.unshift((0...arr[0].size).map { |_| ((".") * (arr[0][0].size)).chars })
  arr
end

state = [[[]]]
input.each_with_index do |line, i|
  state[0][0].push(line.chars)
end
p state
add_border!(state[0])
p state

def deep_copy4(arr)
  newarr = Array.new(arr.size) { Array.new(arr[0].size) { Array.new(arr[0][0].size) { Array.new(arr[0][0][0].size) } } }
  (0...arr.size).each do |i|
    (0...arr[i].size).each do |j|
      (0...arr[i][j].size).each do |k|
        (0...arr[i][j][k].size).each do |h|
          newarr[i][j][k][h] = arr[i][j][k][h]
        end
      end
    end
  end
  newarr
end

def cycle(state)
  z = state[0].size - 2
  y = state[0][0].size - 2
  x = state[0][0][0].size - 2
  state.push(add_border!(Array.new(z) { Array.new(y) { Array.new(x, ".") } }))
  state.push(add_border!(Array.new(z) { Array.new(y) { Array.new(x, ".") } }))
  state.unshift(add_border!(Array.new(z) { Array.new(y) { Array.new(x, ".") } }))
  state.unshift(add_border!(Array.new(z) { Array.new(y) { Array.new(x, ".") } }))
  (0...state.size).each do |i|
    add_border!(state[i])
  end
  # p state
  newstate = deep_copy4(state)
  w = state.size - 2
  z = state[0].size - 2
  y = state[0][0].size - 2
  x = state[0][0][0].size - 2
  (1..w).each do |i|
    (1..z).each do |j|
      (1..y).each do |k|
        (1..x).each do |h|
          count = 0
          (-1..1).each do |dx|
            (-1..1).each do |dy|
              (-1..1).each do |dz|
                (-1..1).each do |dw|
                  next if dx == 0 && dy == 0 && dz == 0 && dw == 0
                  # p [x, y, z, state.size - 2, i + dx, j + dy, k + dz, h + dw]
                  count += 1 if state[i + dw][j + dz][k + dy][h + dx] == "#"
                end
              end
            end
          end
          if state[i][j][k][h] == "#"
            newstate[i][j][k][h] = "." unless count == 2 || count == 3
          else
            newstate[i][j][k][h] = "#" if count == 3
          end
        end
      end
    end
  end

  newstate
end

# def print_state(state)
#   (1..state.size - 2).each do |i|
#     (1..state[i].size - 2).each do |j|
#       p state[i][j]
#     end
#     p " ///// "
#   end
# end

(0...6).each do |i|
  # print_state state
  # p "-----"
  state = cycle(state)
end

p state.flatten.count { |c| c == "#" }
