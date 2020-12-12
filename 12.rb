require 'set'
input = File.read('input12.txt').split("\n")

n = input.size
ans = 0

rot = 0
curdir = [1, 0]
curx = 0
cury = 0

def rot90(dir, reverse)
    res = [0, 0]
    coeff = reverse ? -1 : 1
    if dir == [1, 0]
        res = [0, 1 * coeff]
    elsif dir == [0, 1]
        res = [-1 * coeff, 0]
    elsif dir == [-1, 0]
        res = [0, -1 * coeff]
    elsif dir == [0, -1]
        res = [1 * coeff, 0]
    end

    res
end

input.each_with_index do |line, i|
    dir = line[0]
    num = line[1..].to_i
    newdir = case dir
    when 'N'
        [0, 1]
    when 'S'
        [0, -1]
    when 'E'
        [1, 0]
    when 'W'
        [-1, 0]
    when 'L'
        cnt =  num / 90
        (0...cnt).each do |_|
            curdir = rot90(curdir, false)
        end
        curdir
    when 'R'
        cnt =  num / 90
        (0...cnt).each do |_|
            curdir = rot90(curdir, true)
        end
        curdir
    when 'F'
        curdir
    end
    
    puts "#{dir} #{num}, #{newdir} #{curx},#{cury},#{curdir}"
    next if dir =='R' || dir == 'L'
    curx += newdir[0] * num
    cury += newdir[1] * num
end

puts (curx.abs + cury.abs)