USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

numbers = PUZZLE.lines.map {
  next _1.split(/ +/).map(&:to_i)
}
left_numbers = numbers.map(&:first)
right_numbers = numbers.map(&:last)

puts left_numbers.sort.zip(right_numbers.sort).sum {
  next (_2 - _1).abs
}

puts left_numbers.sum {
  next _1 * right_numbers.count(_1)
}
