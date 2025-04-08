USE_EXAMPLE = false
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
puts GATES.values.filter { _1.output.start_with?(?z) }.map { compute(_1.output, ALL_WIRES) }.join.reverse.to_i(2)
