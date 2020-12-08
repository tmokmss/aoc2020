input = File.read('input6.txt').split("\n")

answered = []
input.unshift('')
input.each do |line|
    if line.empty?
        answered.push(Hash.new(0))
        next
    end

    ans = answered.last

    line.chars.each do |c|
        ans[c] += 1
    end

    ans['count'] += 1
end

puts(answered.map {|a| a.keys.size}.sum)
puts(answered.map {|a| a.select {|k, v| v == a['count'] }.size - 1 }.sum)
