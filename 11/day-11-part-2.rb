USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

stones = PUZZLE.split.map(&:to_i)
value_counts = Hash.new { |h, k| h[k] = 0 }
stones.each { |value| value_counts[value] += 1 }

75.times {
  new_value_counts = Hash.new { |h, k| h[k] = 0 }
  value_counts.each { |value, count|
    if value == 0
      new_value_counts[1] += count
      next
    end
    str = value.to_s
    size = str.size
    if size % 2 == 0
      new_value_counts[str[0..(size / 2 - 1)].to_i] += count
      new_value_counts[str[(size / 2)..-1].to_i] += count
      next
    end
    new_value_counts[value * 2024] += count
  }
  value_counts.replace(new_value_counts)
}

puts value_counts.values.sum
