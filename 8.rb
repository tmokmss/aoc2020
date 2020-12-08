require 'set'
input = File.read('input8.txt').split("\n")

class Op
    attr_reader :op, :sign, :val

    def initialize(op, sign, val)
        @op = op
        @sign = sign
        @val = val.to_i
    end

    def to_s
        "#{self.op} #{self.sign} #{self.val}"
    end
end

ops = input.map do |line|
    args = line.split
    op = args[0]
    sign = args[1][0]
    val = args[1][1..]
    Op.new(op, sign, val)
end


def ends?(ops, switch)
    executed = Set.new
    curr = 0
    acc = 0
    while(true)
        break if curr >= ops.size
        break if executed.add?(curr) == nil

        op = ops[curr]
        operator = op.op
        if switch == curr
            if operator == 'nop'
                operator = 'jmp'
            elsif operator == 'jmp'
                operator = 'nop'
            end
        end

        case operator
        when 'nop'
        when 'acc'
            acc = acc.send(op.sign, op.val)
        when 'jmp'
            curr = curr.send(op.sign, op.val)
            next
        end
        curr += 1
    end

    [acc, curr >= ops.size]
end

acc, _ = ends?(ops, -1)
puts(acc)

(0..ops.size).each do |i|
    acc, completed = ends?(ops, i)
    # puts("#{i} - #{acc} #{completed}")
    break if completed
end

puts(acc)
