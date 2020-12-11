require 'set'
input = File.read('input11.txt').split("\n").map(&:strip)

ans = 0

input.each_with_index do |line, i|
    
end

def add_bound(input)
    h = input.size
    w = input[0].size
    input.unshift('.' * w)
    input.push('.' * w)
    
    (0...input.size).each do |i|
        input[i] = ".#{input[i].strip}."
    end

    input
end

def round(seats)
    seats = add_bound(seats)
    h = seats.size - 2
    w = seats[0].size - 2
    result = []
    changed = false
    (1..h).each do |x|
        resultx = ''
        (1..w).each do |y|
            if seats[x][y] == '.'
                resultx += '.'
                next
            end
            count = 0

            (-1..1).each do |dx|
                (-1..1).each do |dy|
                    next if dx == 0 && dy == 0
                    if seats[x+dx][y+dy] == '#'
                        count +=1
                    end
                end
            end
            if count >= 4
                resultx += 'L'
            elsif count == 0
                resultx += '#'
            else
                resultx += seats[x][y]
            end
            changed ||= resultx[-1] != seats[x][y]
        end
        result.push(resultx)
    end

    [result, changed]
end

# result = input
# changed = true
# count = 0
# while(changed) do
#     # puts result
#     # puts '*********************************'
#     # puts count
#     result, changed = round(result)
#     count += 1
#     # sleep 0.3
# end

# ans = result.map {|r| r.count('#')}.sum
# puts ans # part 1 answer

def round2(seats)
    h = seats.size
    w = seats[0].size
    result = []
    changed = false
    (0...h).each do |x|
        resultx = ''
        (0...w).each do |y|
            if seats[x][y] == '.'
                resultx += '.'
                next
            end
            count = 0

            (-1..1).each do |dx|
                (-1..1).each do |dy|
                    next if dx == 0 && dy == 0
                    (1..100).each do |coeff|
                        cdx = dx * coeff
                        cdy = dy * coeff
                        break if x + cdx >= h || x + cdx < 0
                        break if y + cdy >= w || y + cdy < 0

                        if seats[x+cdx][y+cdy] == '#'
                            count +=1
                            break
                        elsif seats[x+cdx][y+cdy] == 'L'
                            break
                        end
                    end
                end
            end
            if count >= 5
                resultx += 'L'
            elsif count == 0
                resultx += '#'
            else
                resultx += seats[x][y]
            end
            changed ||= resultx[-1] != seats[x][y]
        end
        result.push(resultx)
    end

    [result, changed]
end

result = input
changed = true
count = 0
while(changed) do
    # sleep 0.3
    # puts result
    # puts '*********************************'
    puts count
    result, changed = round2(result)
    count += 1
end

ans = result.map {|r| r.count('#')}.sum
puts ans # part 1 answer
