require 'set'
input = File.read('input/8.txt').split("\n")

class Op
    attr_reader :op, :val

    def initialize(op, val)
        @op = op
        @val = val.to_i
    end

    def to_s
        "#{self.op} #{self.val}"
    end

    def flip!
        if @op == 'nop'
            @op = 'jmp'
        elsif @op == 'jmp'
            @op = 'nop'
        end
    end
end

ops = input.map do |line|
    args = line.split
    op = args[0]
    val = args[1]
    Op.new(op, val)
end


def ends?(ops)
    executed = Set.new
    curr = 0
    acc = 0
    loop do
        break if curr >= ops.size
        break if executed.add?(curr) == nil

        op = ops[curr]

        case op.op
        when 'nop'
        when 'acc'
            acc += op.val
        when 'jmp'
            curr += op.val
            next
        end
        curr += 1
    end

    [acc, curr >= ops.size]
end

acc, _ = ends?(ops)
puts(acc)

(0..ops.size).each do |i|
    ops[i].flip!
    acc, completed = ends?(ops)
    ops[i].flip!
    break if completed
end

puts(acc)
