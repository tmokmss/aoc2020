input = File.read('input/4.txt').split("\n")

FIELDS = [
'byr',
'iyr',
'eyr',
'hgt',
'hcl',
'ecl',
'pid',
#'cid',
]

def parse_input(input)
    result = [{}]
    
    input.each do |line|
        if line.empty?
            result.push({})
        end

        fields = line.split.map{|pair| pair.split(':')}.to_h
        result.last.merge!(fields)
    end

    result
end

def all_fields_exists?(table)
    FIELDS.each do |field|
        return false unless table.has_key?(field)
    end

    true
end

def exactly_match?(pattern, str)
    match = pattern.match(str)
    return false if match.nil?
    match[0] == str
end

def all_fields_valid?(table)
    byr = table['byr'].to_i
    return false if byr < 1920 || byr > 2002
    iyr = table['iyr'].to_i
    return false if iyr < 2010 || iyr > 2020
    eyr = table['eyr'].to_i
    return false if eyr < 2020 || eyr > 2030

    if table['hgt'].end_with?('cm') 
        hgt = table['hgt'][0..-3].to_i
        return false if hgt < 150 || hgt > 193
    elsif table['hgt'].end_with?('in')
        hgt = table['hgt'][0..-3].to_i
        return false if hgt < 59 || hgt > 76
    else 
        return false
    end

    return false unless exactly_match?(/\#[0-9,a-f]{6}/, table['hcl'])
    return false unless ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(table['ecl'])
    return false unless exactly_match?(/[0-9]{9}/, table['pid'])

    puts table
    true
end

passports = parse_input(input)
#puts(passports.count{|p| all_fields_exists?(p)})
puts(passports.select{|p| all_fields_exists?(p)}.count{|p| all_fields_valid?(p)})
