USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

register_a, register_b, register_c, program = *PUZZLE.split(?\n).reject(&:empty?).map { _1.scan(/\d+/).map(&:to_i) }
register_a, register_b, register_c = *[register_a, register_b, register_c].map(&:first)

class MissingOperandException < Exception
end

class Computer
  attr_reader :output

  INSTRUCTIONS = [:adv, :bxl, :bst, :jnz, :bxc, :out, :bdv, :cdv]

  def initialize(register_a, register_b, register_c, program)
    @register_a, @register_b, @register_c, @program = register_a, register_b, register_c, program
    @pointer = 0
    @output = []
  end

  def process
    instruction = read_instruction()
    begin
      loop do
        break unless instruction
        if instruction == :jnz
          if @register_a.zero?
            instruction = read_instruction()
          else
            @pointer = read_operand()
            instruction = INSTRUCTIONS[@program[@pointer]]
            @pointer += 1
          end
        else
          send(instruction)
          instruction = read_instruction()
        end
      end
    rescue MissingOperandException
    end
  end

  def read_instruction
    instruction_code = @program[@pointer]
    @pointer += 1
    return INSTRUCTIONS[instruction_code]
  end

  def read_operand
    operand = @program[@pointer]
    raise MissingOperandException unless operand
    @pointer += 1
    return operand
  end

  def operand_to_combo_operand(operand)
    return operand if operand <= 3
    return @register_a if operand == 4
    return @register_b if operand == 5
    return @register_c if operand == 6
    raise "invalid operand"
  end

  def read_combo_operand
    return operand_to_combo_operand(read_operand())
  end

  def adv
    @register_a /= 2 ** read_combo_operand()
  end

  def bxl
    @register_b ^= read_operand()
  end

  def bst
    @register_b = read_combo_operand() % 8
  end

  def bxc
    read_operand()
    @register_b ^= @register_c
  end

  def out
    @output << read_combo_operand() % 8
  end

  def bdv
    @register_b = @register_a / 2 ** read_combo_operand()
  end

  def cdv
    @register_c = @register_a / 2 ** read_combo_operand()
  end
end

computer = Computer.new(register_a, register_b, register_c, program)
computer.process
puts computer.output.join(",")

# __END__

# (8 ** 15...8 ** 15 + 10000).each { |i|
#   computer = Computer.new(i, register_b, register_c, program)
#   computer.process
#   puts computer.output.join(",")
#   if computer.output.join(",") == program.join(",")
#     puts i
#     break
#   end
# }

# from https://github.com/gchan/advent-of-code-ruby/blob/main/2024/day-17/day-17-part-2.rb

registers, commands = PUZZLE.split("\n\n")
reg = registers.scan(/\d+/).map(&:to_i)
cmds = commands.scan(/\d+/).map(&:to_i)

def run(cmds, a_reg)
  reg = [a_reg, 0, 0]

  out = []

  ptr = 0

  while ptr < cmds.length
    cmd, op = cmds[ptr], cmds[ptr + 1]

    lit = op
    co = op
    if op >= 4 && op <= 6
      co = reg[op - 4]
    end

    case cmd
    when 0
      reg[0] = reg[0] / (2 ** co)
    when 1
      reg[1] = reg[1] ^ lit
    when 2
      reg[1] = co % 8
    when 3
      if reg[0] != 0 && lit != ptr
        ptr = lit
        next
      end
    when 4
      reg[1] = reg[1] ^ reg[2]
    when 5
      out << co % 8
    when 6
      reg[1] = reg[0] / (2 ** co)
    when 7
      reg[2] = reg[0] / (2 ** co)
    end

    ptr += 2
  end

  return out
end

# The device runs in a loop and prints an output once per loop.
# At the end of the one loop, the least significant 3 bits are discarded.
# Registers B and C are derived by the A register at the start of each
# iteration of the loop
#
# So we can build up the desired output from building up the value of A
# by shifting the value by 3 bits in each iteration (i.e. multiplying A
# by 8). The search space is 3 bits (8 values) each time so it's feasible
# to 'brute force'.

goal = cmds.clone

target = []
solutions = [0] # to initialise the search space, zero not a valid solution!

while goal.any?
  target.unshift(goal.pop)

  new_solutions = []

  solutions.each {
    solution = _1 * 8

    from = solution
    to = solution + 8

    (from..to).each { |input|
      out = run(cmds, input)
      new_solutions << input if out == target
    }
  }

  solutions = new_solutions
end

puts solutions.min
