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
    row.each_with_index { |cell, x| antennas << [x, y] if cell == frequency }
  }
  antennas.each { |(x1, y1)|
    antennas.each { |(x2, y2)|
      next if x2 == x1 && y2 == y1
      next if antennas_grid[y1][x1] != antennas_grid[y2][x2]
      antennas_grid.each_with_index { |row, y3|
        row.each_with_index { |cell, x3|
          next if antinodes_grid[y3][x3] == ?#
          coef12 = x2 - x1 == 0 ? nil : (y2.to_f - y1) / (x2 - x1)
          coef13 = x3 - x1 == 0 ? nil : (y3.to_f - y1) / (x3 - x1)
          if coef12 == coef13
            antinodes_grid[y3][x3] = ?#
          end
        }
      }
    }
  }
}
antinodes_str = antinodes_grid.map { _1.join("") }.join(?\n)

puts antinodes_str.count(?#)
