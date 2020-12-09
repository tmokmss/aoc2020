require 'set'
input = File.read('input9.txt').split("\n").map(&:to_i)


def search_pair(num, gen)
    (0...gen.size).each do |i|
        (i+1...gen.size).each do |j|
            return gen[i], gen[j] if gen[i] + gen[j] == num
        end
    end

    nil
end

amble = 25
ans = 0
(amble...input.size).each do |i|
    num = input[i]
    before = input[i-amble..i-1]
    ret = search_pair(num, before)
    if ret.nil?
        ans = num
        break
    end
end

puts(ans)

invalid = ans

(0...input.size).each do |i|
    (i+1...input.size).each do |j|
        if input[i..j].sum == invalid
            ans = input[i] + input[j]
            break
        end
    end
end

puts(ans)
