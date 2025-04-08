USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

stones = PUZZLE.split.map(&:to_i)

25.times {
  new_stones = []
  stones.each { |stone|
    if stone == 0
      new_stones << 1
      next
    end
    str = stone.to_s
    size = str.size
    if size % 2 == 0
      new_stones << str[0..(size / 2 - 1)].to_i
      new_stones << str[(size / 2)..-1].to_i
      next
    end
    new_stones << stone * 2024
  }
  stones.replace new_stones
}

puts stones.size
