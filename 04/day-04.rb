require "matrix"

USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

XMAS = "XMAS"
SAMX = XMAS.reverse

count = PUZZLE.scan(XMAS).count + PUZZLE.scan(SAMX).count

grid = PUZZLE.lines.map {
  next _1.strip.split ""
}

transposed_puzzle = grid.transpose.map(&:join).join(?\n)

count += transposed_puzzle.scan(XMAS).count + transposed_puzzle.scan(SAMX).count

grid[0..-XMAS.size].each_with_index { |row, y|
  row.each_with_index { |letter, x|
    if x <= row.length - XMAS.size
      str = letter + grid[y + 1][x + 1] + grid[y + 2][x + 2] + grid[y + 3][x + 3]
      count += (str.match?(XMAS) ? 1 : 0) + (str.match?(SAMX) ? 1 : 0)
    end
    if x >= XMAS.size - 1
      str = letter + grid[y + 1][x - 1] + grid[y + 2][x - 2] + grid[y + 3][x - 3]
      count += (str.match?(XMAS) ? 1 : 0) + (str.match?(SAMX) ? 1 : 0)
    end
  }
}

puts count

count = 0
grid[1..-2].each_with_index { |row, i|
  y = i + 1
  row[1..-2].each_with_index { |letter, j|
    x = j + 1
    next unless letter == ?A
    next unless (grid[y - 1][x - 1] == ?S && grid[y + 1][x + 1] == ?M) || (grid[y - 1][x - 1] == ?M && grid[y + 1][x + 1] == ?S)
    count += 1 if (grid[y + 1][x - 1] == ?S && grid[y - 1][x + 1] == ?M) || (grid[y + 1][x - 1] == ?M && grid[y - 1][x + 1] == ?S)
  }
}

puts count
