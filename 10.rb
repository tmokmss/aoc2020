input = File.read('input10.txt').split("\n").map(&:to_i)
input.push(0)
input.push(input.max+3)
input.sort!
n = input.size

adapter = input.last

count = Hash.new(0)
(0...n-1).each do |i|
    count[input[i+1] - input[i]] += 1
end

puts(count[1] * count[3])

dp = Array.new(n, 0)
dp[n-1] = 1
(1...n).each do |i|
    j = n - i - 1
    v = input[j]
    (1..3).each do |k|
        break if j+k >= n
        if (input[j+k] <= v + 3)
            dp[j] += dp[j+k]
        else 
            break
        end
    end
end

(0...n).each do |i|
    # puts "#{input[i]}, #{dp[i]}"
end
puts dp[0]
