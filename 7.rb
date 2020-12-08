require 'set'

input = File.read('input7.txt').split("\n")

bags = {}
input.map {|i| i.gsub(/\,|\./, '')}.each do |line|
    current_subject = ''
    current_object = ''
    subject = true
    line.split.each do |word|
        case word
        when 'bags', 'bag'
            unless subject
                bags[current_object] = Set.new if bags[current_object].nil?
                bags[current_object].add(current_subject)
            end
            current_object = ''
        when 'contain'
            subject = false
        when *((1..9).map(&:to_s))
        else
            current_subject += word + ' ' if subject
            current_object += word + ' ' unless subject
        end
    end
end

def get_bag_count(color, bags, ans)
    return if bags[color].nil?
    bags[color].each do |bag|
        ans.add(bag)
        get_bag_count(bag, bags, ans)
    end

    ans
end

puts(bags.size)
ans = Set.new
get_bag_count('shiny gold ', bags, ans)
puts(ans.size)


bags2 = {}
input.map {|i| i.gsub(/\,|\./, '')}.each do |line|
    current_subject = ''
    current_object = ''
    current_number = 0
    subject = true
    line.split.each do |word|
        case word
        when 'bags', 'bag'
            unless subject
                bags2[current_subject].push([current_object, current_number])
            end
            current_object = ''
        when 'contain'
            bags2[current_subject] = []
            subject = false
        when *((1..9).map(&:to_s))
            current_number = word.to_i
        else
            current_subject += word + ' ' if subject
            current_object += word + ' ' unless subject
        end
    end
end

def get_bags_count2(color, bags)
    ans = 0
    return 0 if bags[color].nil?
    bags[color].each do |bag|
        ans += bag[1]
        ans += bag[1] * get_bags_count2(bag[0], bags)
    end

    ans
end

puts(bags2['shiny gold '])
puts(get_bags_count2('shiny gold ', bags2))
