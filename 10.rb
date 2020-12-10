require 'set'
input = File.read('input10.txt').split("\n").map(&:to_i).sort!

ans = 0
adapter = input.last + 3

charging_outlet = input.select {|i| i <= 3}.size

count = Hash.new(0)
last = 0
input.each_with_index do |line, i|
    count[line - last] += 1
    last = line
end
count[3] += 1

puts(count[1] * count[3])

# dp = (0...input.size).map {|i| Array.new(input.size) }
# (0...input.size).each do |i|
#     (0...input.size).each do |j|
#         dp[i][j] = 
#     end
# end

n = input.size
dp = Array.new(n+2, 0)
dp[n] = 1
input.unshift(0)
input.push(adapter)
(0...n+1).each do |i|
    j = n - i - 1
    v = input[j]
    (1..3).each do |k|
        break if j+k > n
        if (input[j+k] <= v + 3)
            dp[j] += dp[j+k]
        else 
            break
        end
    end
end


(0..n+1).each do |i|
    puts "#{input[i]}, #{dp[i]}"
end
puts dp[0]