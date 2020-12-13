input = File.read('input/5.txt').split("\n")

seats = input.map {|i| i.gsub(/B|R/, '1').gsub(/F|L/, '0')}.map {|i| i.to_i(2)}.sort!
puts(seats.last)

ans = 0
(0...seats.size-1).each do |i|
    if seats[i] != seats[i+1] - 1
        ans = seats[i] + 1
        break
    end
end

puts(ans)