USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

numbers = PUZZLE.split(?\n * 2).map { _1.scan(/\d+/).map(&:to_i) }

puts numbers.map {
  a_x, a_y, b_x, b_y, p_x, p_y = *_1
  p_x += 10 ** 13
  p_y += 10 ** 13
  s_a = (p_y * b_x - b_y * p_x) / (a_y * b_x - b_y * a_x).to_f
  s_b = (p_x - a_x * s_a) / b_x
  next (s_a * 3 + s_b).to_i if s_a.to_i == s_a && s_b.to_i == s_b
}.reject(&:nil?).sum
