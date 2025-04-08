USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
_tmp = PUZZLE.split(?\n, 3)
PATTERNS = _tmp[0].split(", ")
DESIGNS = _tmp[2].split(?\n)
_tmp = nil

def possible?(design)
  return true if design.empty?
  candidates = PATTERNS.select { design.start_with?(_1) }
  return candidates.any? { possible?(design[_1.size..]) }
end

puts DESIGNS.count { possible?(_1) }

def possibilities(design, patterns, known = {})
  return 1 if design.empty?
  known[design] ||= patterns.sum { |pattern|
    next 0 unless design.start_with?(pattern)
    next possibilities(design[pattern.length..], patterns, known)
  }
end

puts DESIGNS.sum { possibilities(_1, PATTERNS) }

__END__

# --- TOO SLOW ---
def possibilities design, stack = []
    return [stack] if design.empty?
    candidates = PATTERNS.select { design.start_with?(_1) }
    return candidates.map { possibilities(design[_1.size..], [*stack, _1]) }.flatten(1)
end

# --- STILL TOO SLOW ---
def possibilities_count design
    return 1 if design.empty?
    candidates = PATTERNS.select { design.start_with?(_1) }
    return candidates.map { possibilities_count(design[_1.size..]) }.sum
end
