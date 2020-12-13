require 'set'
input = File.read('input/9.txt').split("\n").map(&:to_i)


def search_pair(num, gen)
    gen.each_with_index do |a, i|
        gen[i+1..].each do |b|
            return a, b if a + b == num
        end
    end

    nil
end

amble = 25
ans = 0
(amble...input.size).each do |i|
    num = input[i]
    before = input[i-amble...i]
    ret = search_pair(num, before)
    if ret.nil?
        ans = num
        break
    end
end

puts(ans)

invalid = ans
ssum = [0]
(0...input.size).each do |i|
    ssum.push(ssum[i] + input[i])
end

(0..input.size).each do |i|
    # pick more than one elements.
    (i+2..input.size).each do |j|
        sum = ssum[j] - ssum[i]
        if sum == invalid
            ans = input[i] + input[j-1]
            break
        end
        break if sum > ans
    end
end

puts(ans)
