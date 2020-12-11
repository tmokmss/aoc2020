require 'set'
input = File.read('input11.txt').split("\n").map(&:strip)

def round(seats, occupied_threshold, allowed_distance)
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
                    (1..allowed_distance).each do |coeff|
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
            if count >= occupied_threshold
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

def solve(input, occupied_threshold, allowed_distance)
    result = input
    changed = true
    count = 0
    while(changed) do
        result, changed = round(result, occupied_threshold, allowed_distance)
        count += 1
    end
    
    result.map {|r| r.count('#')}.sum
end

puts solve(input, 4, 1)
puts solve(input, 5, 100)

