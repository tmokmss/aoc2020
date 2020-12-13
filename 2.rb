input = File.read('input/2.txt').split("\n")

def is_valid(str, min, max, char)
    c = str.count(char)
    c >= min && c <= max
end

def is_valid2(str, min, max, char)
    (str[min-1] == char) ^ (str[max-1] == char)
end

ans = 0
input.each do |line|
    args = line.split
    min, max = args[0].split('-').map(&:to_i)
    char = args[1][0]
    str = args[2]
    ans += 1 if is_valid2(str, min, max, char)
    puts(line) if is_valid2(str, min, max, char)
end

puts(ans)