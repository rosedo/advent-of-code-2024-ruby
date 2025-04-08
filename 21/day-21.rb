USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
CODES = PUZZLE.split(?\n)
NUMERIC_KEYPAD = {
  [0, 0] => ?7, [1, 0] => ?8, [2, 0] => ?9,
  [0, 1] => ?4, [1, 1] => ?5, [2, 1] => ?6,
  [0, 2] => ?1, [1, 2] => ?2, [2, 2] => ?3,
  [1, 3] => ?0, [2, 3] => ?A,
}
DIRECTIONAL_KEYPAD = {
  [1, 0] => ?^, [2, 0] => ?A,
  [0, 1] => ?<, [1, 1] => ?v, [2, 1] => ?>,
}
CACHE = {}

def sequence(layout, from, to)
  seq = []
  p1, p2 = layout.key(from), layout.key(to)
  move_x, move_y = p2[0] - p1[0], p2[1] - p1[1]
  if move_x < 0 && layout.key?([p1[0] + move_x, p1[1]])
    move_x.abs.times { seq << ?< }
    move_y.abs.times { seq << (move_y < 0 ? ?^ : ?v) }
  elsif layout.key?([p1[0], p1[1] + move_y])
    move_y.abs.times { seq << (move_y < 0 ? ?^ : ?v) }
    move_x.abs.times { seq << (move_x < 0 ? ?< : ?>) }
  else
    move_x.abs.times { seq << (move_x < 0 ? ?< : ?>) }
    move_y.abs.times { seq << (move_y < 0 ? ?^ : ?v) }
  end
  seq << ?A
  return seq.join
end

def directional_presses(code, robots)
  return CACHE[[code, robots]] ||= "A#{code}".chars.each_cons(2).sum {
           seq = sequence(DIRECTIONAL_KEYPAD, _1, _2)
           next robots.zero? ? seq.length : directional_presses(seq, robots - 1)
         }
end

def key_presses(code, robots)
  entry = "A#{code}".chars.each_cons(2).map { sequence(NUMERIC_KEYPAD, _1, _2) }.join
  return directional_presses(entry, robots - 1)
end

puts CODES.sum { _1.to_i * key_presses(_1, 2) }
puts CODES.sum { _1.to_i * key_presses(_1, 25) }
