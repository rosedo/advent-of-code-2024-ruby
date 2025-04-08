USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
CODES = PUZZLE.split(?\n)
NUMERIC_KEYPAD = [
  [?7, ?8, ?9],
  [?4, ?5, ?6],
  [?1, ?2, ?3],
  [?X, ?0, ?A],
]
DIRECTIONAL_KEYPAD = [
  [?X, ?^, ?A],
  [?<, ?v, ?>],
]

def keypad_position(keypad, char)
  keypad.each_with_index { |row, y| row.each_with_index { |cell, x| return [x, y] if cell == char } } && raise
end

def sequence_valid?(keypad, (x, y), sequence)
  forbidden_position = keypad_position(keypad, ?X)
  sequence.each {
    x += 1 if _1 == ?>
    x -= 1 if _1 == ?<
    y -= 1 if _1 == ?^
    y += 1 if _1 == ?v
    return false if [x, y] == forbidden_position
  }
  return true
end

def basic_shortest_sequences(keypad, (x1, y1), char)
  (x2, y2) = keypad_position(keypad, char)
  dx, dy = x2 - x1, y2 - y1
  x_char, y_char = dx < 0 ? ?< : ?>, dy < 0 ? ?^ : ?v
  candidates = ([x_char] * dx.abs + [y_char] * dy.abs).permutation.uniq
  return candidates.filter { sequence_valid?(keypad, [x1, y1], _1) }.map { _1.tap { |list| list << ?A } }
end

def shortest_sequences(keypad, code)
  result, position = [[]], keypad_position(keypad, ?A)
  code.each_char { |char|
    updated_result, basic_sequences = [], basic_shortest_sequences(keypad, position, char)
    result.each { |seq| updated_result.push(*basic_sequences.map { seq + _1 }) }
    result, position = updated_result, keypad_position(keypad, char)
  }
  raise if result.map(&:size).uniq.size != 1
  return result
end

def keep_shortest(sequences)
  min = sequences.map(&:size).min
  return sequences.filter { _1.size == min }
end

puts CODES.map { |code|
  sequences = shortest_sequences(NUMERIC_KEYPAD, code)
  sequences = keep_shortest(sequences.map { shortest_sequences(DIRECTIONAL_KEYPAD, _1.join) }.flatten(1))
  size = sequences.map { shortest_sequences(DIRECTIONAL_KEYPAD, _1.join) }.flatten(1).map(&:size).min
  next size * code.to_i
}.sum
