require "set"

if ARGV.length < 1
  input_path = "input/20.txt"
else
  input_path = "sample/20.txt"
end

puts "Load input from #{input_path}"

input = File.read(input_path).split("\n").map(&:strip)

class Image
  attr_accessor :position, :rotation, :flip, :id

  def initialize
    @data = []
    @w = 0
    @connection = Array.new(4, nil)
    # 0
    #3 1
    # 2
    # 0 : 2
    # 1 : 3
  end

  def add_row(row)
    @data.push(row)
    @w = row.size
  end

  def get_borders
    borders = Array.new(4) { Array.new(@w) }
    (0...@w).each do |i|
      borders[0][i] = @data[0][i]
      borders[1][i] = @data[i][@w - 1]
      borders[2][i] = @data[@w - 1][i]
      borders[3][i] = @data[i][0]
      #   0
      # 3 O 1
      #   2
    end

    borders.map { |a| a.join }
  end

  def add_connection(idx, image)
    raise if @connection[idx] != nil
    @connection[idx] = image
  end

  def rotate90!
    new_data = Array.new(@w) { Array.new(@w) }
    (0...@w).each do |i|
      (0...@w).each do |j|
        new_data[@w - j - 1][i] = @data[i][j]
      end
    end
    @data = new_data
    self
  end

  def flip!
    new_data = Array.new(@w) { Array.new(@w) }
    (0...@w).each do |i|
      (0...@w).each do |j|
        new_data[@w - i - 1][j] = @data[i][j]
      end
    end
    @data = new_data
    self
  end

  def print
    @data.each do |row|
      p row
    end
  end
end

images = Hash.new { |h, k| h[k] = Image.new }
curr = -1

input.each_with_index do |line, i|
  next if line.empty?
  if line.start_with?("Tile")
    curr = line[4..-1].to_i
    next
  end
  images[curr].id = curr
  images[curr].add_row(line.chars)
end

border_map = Hash.new { |h, k| h[k] = [] }
images.each do |id, image|
  borders = image.get_borders
  borders.each do |border|
    border_map[border].push(image.id)
    border_map[border.reverse].push(image.id)
  end
end

matched = Hash.new { |h, k| h[k] = [] }
images.each do |id, image|
  borders = image.get_borders
  borders.each_with_index do |border, i|
    m = border_map[border].reject { |a| a == image.id }
    next if m.empty?
    matched[image.id].push([m, i, i == 1])
  end
end

p matched.select { |_, m| m.size == 2 }.map { |id, _| id }.inject(&:*)
p matched.select { |_, m| m.size == 2 }

MONSTER =
  "
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
"

width = Integer.sqrt(images.size)
image = Array.new(width) { Array.new(width, nil) }
corner = matched.select { |_, m| m.size == 2 }.first
