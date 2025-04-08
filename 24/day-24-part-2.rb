# --- Part 2 --- solving for specific input ---

USE_EXAMPLE = false # part 2 not implemented for example input
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
_wires, _gates = *PUZZLE.split(?\n * 2).map { _1.split(?\n) }
INPUT_WIRES = _wires.map { |str| str.split(": ").tap { _1[1] = _1[1].to_i } }.to_h.tap(&:freeze)
Gate = Data.define(:input_1, :gate, :input_2, :output)
GATES = _gates.map { |str| str.split.tap { _1.delete_at(3) } }.map { Gate.new(*_1) }.map { [_1.output, _1] }.sort.to_h
OPS = { "AND" => :&, "OR" => :|, "XOR" => :^ }

def compute(wire, wires)
  wires[wire] ||= INPUT_WIRES[wire]
  wires[wire] ||= begin
      gate = GATES[wire]
      compute(gate.input_1, wires).send(OPS[gate.gate], compute(gate.input_2, wires))
    end
end

ALL_WIRES = INPUT_WIRES.dup
GATES.values.filter { _1.output.start_with?(?z) }.map { compute(_1.output, ALL_WIRES) }.join.reverse.to_i(2)
N_DIGITS = INPUT_WIRES.size / 2
Z_DIGITS = N_DIGITS + 1

def compute_with(x, y)
  compute_with_str(*[x, y].map { _1.to_s(2).rjust(N_DIGITS, ?0) })
end

def compute_with_str(x_str, y_str)
  wires = {}
  add_wires_for(?x, x_str, wires)
  add_wires_for(?y, y_str, wires)
  z_str = GATES.values.filter { _1.output.start_with?(?z) }.map { compute(_1.output, wires) }.join.reverse
  expected = [x_str, y_str].map { _1.to_i(2) }.sum.to_s(2).rjust(Z_DIGITS, ?0)
  return { x: x_str, y: y_str, z: z_str, z_expected: expected, match: z_str == expected }
end

def add_wires_for(prefix, digits_str, wires)
  index = 0
  digits_str.reverse.each_char {
    wires[prefix + index.to_s.rjust(2, ?0)] = _1.to_i
    index += 1
  }
end

def deps(output_wire, include_input = true, include_output = true)
  raise "not an output wire" if output_wire.start_with?(?x, ?y)
  wires = {}
  compute(output_wire, wires)
  wires.delete(output_wire) unless include_output
  return include_input ? wires.keys : wires.keys - INPUT_WIRES.keys
end

def test_between(first, last)
  first.upto(last).each { |x|
    first.upto(last).each { |y|
      if (!compute_with(x, y)[:match])
        return [x, y, compute_with(x, y)]
      end
    }
  }
end

# p test_between(0, 100) # for x = 0, y = 32, we get ...1000000 instead of ...100000 -> the lowest invalid bit is z05

valid_wires = Set[*INPUT_WIRES.keys]
5.times { valid_wires += deps(?z + _1.to_s.rjust(2, ?0)) }
# suspects = deps("z05") - valid_wires.to_a # ["z05", "rnk", "tsw", "dmh", "dsn", "wwm", "mkq"]
unknowns = (ALL_WIRES.keys - valid_wires.to_a) # 203 wires

# 46.times { p GATES[?z + _1.to_s.rjust(2, ?0)] }
# it appears z bits are computed from XOR gates from non-x non-y inputs (except for the first and last bits)
# z05, z09 and z30 do not respect these rules

# p deps("z00", false).size
# 1.upto(45) {
#   p ?z + _1.to_s.rjust(2, ?0) => (deps(?z + _1.to_s.rjust(2, ?0), false) - deps(?z + (_1 - 1).to_s.rjust(2, ?0), false)).size
# }
# it seems every z bit should have 4 new deps compared to the previous bit (except for the first and last bits)
# z05, 09 and the bits right after do not respect these rules (z30 does but we know z30 is invalid)

# GATES.each { |output, gate|
#   next if output.start_with?(?z) || gate.gate != "XOR" || [gate.input_1, gate.input_2].any? { _1.start_with?(?x, ?y) }
#   p output => deps(output, false).size
# }
# the gbf, hdt and nbf gates match the z criteria, so we'll have to swap them with z05, z09 and z30
# hdt has the lowest number of deps (z05) and nbf the highest (z30)

def swap(output_1, output_2)
  tmp1, tmp2 = GATES[output_1], GATES[output_2]
  GATES[output_2] = Gate.new(tmp1.input_1, tmp1.gate, tmp1.input_2, tmp2.output)
  GATES[output_1] = Gate.new(tmp2.input_1, tmp2.gate, tmp2.input_2, tmp1.output)
end

swap("z05", "hdt")
swap("z09", "gbf")
swap("z30", "nbf")

possible_swaps = Set[]
unknowns.each { |wire1| unknowns.each { |wire2| possible_swaps << [wire1, wire2].sort if wire2 != wire1 } }

# brute force to find the last two
# possible_swaps_2 = []
# possible_swaps.each { |wire1, wire2|
#   swap(wire1, wire2)
#   begin
#     match = compute_with_str(?0 * N_DIGITS, ?0 * N_DIGITS)[:match]
#     match &&= compute_with_str(?0 * N_DIGITS, ?1 * N_DIGITS)[:match]
#     match &&= compute_with_str(?1 * N_DIGITS, ?0 * N_DIGITS)[:match]
#     match &&= compute_with_str(?1 * N_DIGITS, ?1 * N_DIGITS)[:match]
#   rescue SystemStackError
#   end
#   possible_swaps_2 << [wire1, wire2] if match
#   swap(wire1, wire2)
# }
# p possible_swaps_2

possible_swaps_2 = [["jgt", "mht"], ["mht", "wnd"], ["fgc", "jgt"], ["fgc", "wnd"], ["bwr", "jgt"], ["bwr", "wnd"]]
possible_swaps_3 = []
possible_swaps_2.each { |wire1, wire2|
  swap(wire1, wire2)
  match = compute_with_str("000000000000000000000000000000000000000000001", "111111111111111111111111111111111111111111111")[:match]
  possible_swaps_3 << [wire1, wire2] if match
  swap(wire1, wire2)
}
# p possible_swaps_3 # [["jgt", "mht"]]

puts ["z05", "hdt", "z09", "gbf", "z30", "nbf", "jgt", "mht"].sort.join(",")
