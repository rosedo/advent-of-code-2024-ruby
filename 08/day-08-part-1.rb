USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

antennas_grid = PUZZLE.split(?\n).map { _1.split("") }
antinodes_grid = antennas_grid.dup.map { _1.dup }
frequencies = antennas_grid.flatten.uniq.select { _1 =~ /[\da-z]/i }
width = antennas_grid[0].size
height = antennas_grid.size

frequencies.each { |frequency|
  antennas = []
  antennas_grid.each_with_index { |row, y|
    row.each_with_index { |cell, x|
      antennas << [x, y] if cell == frequency
    }
  }
  antennas.each { |(x1, y1)|
    antennas.each { |(x2, y2)|
      next if x2 == x1 && y2 == y1
      antinode1 = [x1 + (x1 - x2), y1 + (y1 - y2)]
      antinode2 = [x2 + (x2 - x1), y2 + (y2 - y1)]
      valid_antinodes = [antinode1, antinode2].select { |x, y|
        next x >= 0 && x < width && y >= 0 && y < height
      }
      valid_antinodes.each { |x, y|
        antinodes_grid[y][x] = ?#
      }
    }
  }
}
antinodes_str = antinodes_grid.map { _1.join("") }.join(?\n)

puts antinodes_str.count(?#)
