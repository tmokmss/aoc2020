require "set"

if ARGV.length < 1
  input_path = "input/25.txt"
else
  input_path = "sample/25.txt"
end

puts "Load input from #{input_path}"

REM = 20201227
MUL = 7

input = File.read(input_path).split("\n").map(&:strip).map(&:to_i)
cardp = input[0]
doorp = input[1]

def calc_loop_size(pub)
  now = 1
  count = 0
  loop do
    count += 1
    now *= MUL
    now %= REM
    break if now == pub
  end

  count
end

def encrypt(pub, count)
  enc = 1
  count.times do
    enc *= pub
    enc %= REM
  end
  enc
end

card_loop = calc_loop_size(cardp)
door_loop = calc_loop_size(doorp)
doorenc = encrypt(doorp, card_loop)

p card_loop
p doorenc
