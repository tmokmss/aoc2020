input = File.read('input3.txt').split("\n")

def count_trees(lines, slopex, slopey)
    w = lines[0].size
    h = lines.size
    ans = 0
    current = 0
    lines[slopey..].filter.with_index { |_, i| i % slopey == 0 }.each do |line|
        current = (current + slopex) % w
        ans += 1 if line[current] == '#'
        puts("#{ans} #{current} #{line}")
    end

    ans
end

ans = 1
steps = [[1,1], [3,1], [5,1], [7,1], [1,2]]
steps.each do |step|
    ans *= count_trees(input, step[0], step[1])
end

# puts(count_trees(input, 3, 1))
puts(ans)
