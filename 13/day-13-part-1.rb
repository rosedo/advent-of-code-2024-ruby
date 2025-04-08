USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

numbers = PUZZLE.split(?\n * 2).map { _1.scan(/\d+/).map(&:to_i) }

puts numbers.map {
  a_x, a_y, b_x, b_y, p_x, p_y = *_1
  a_max = [p_x / a_x, p_y / a_y].min + 1
  b_max = [p_x / b_x, p_y / b_y].min + 1
  valid_press_counts = []
  a_max.times { |a|
    b_max.times { |b|
      valid_press_counts << [a, b] if a * a_x + b * b_x == p_x && a * a_y + b * b_y == p_y
    }
  }
  next valid_press_counts.map { |(a, b)| a * 3 + b }.min
}.reject(&:nil?).sum
