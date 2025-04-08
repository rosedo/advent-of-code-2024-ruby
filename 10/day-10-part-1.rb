USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

TOPO_MAP = PUZZLE.split(?\n).map { _1.split("").map(&:to_i) }
WIDTH = TOPO_MAP[0].size
HEIGHT = TOPO_MAP.size

def cell_at(x, y)
  return nil if x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT
  return TOPO_MAP[y][x]
end

def trail_ends(x, y, start)
  return Set[] if cell_at(x, y) != start
  return Set[[x, y]] if start == 9
  ends = Set[]
  [[-1, 0], [1, 0], [0, -1], [0, 1]].each { |(delta_x, delta_y)|
    trail_ends(x + delta_x, y + delta_y, start + 1).each { ends.add _1 }
  }
  return ends
end

trails = {}
TOPO_MAP.each_with_index { |row, y|
  row.each_with_index { |cell, x|
    score = trail_ends(x, y, 0).size
    trails[[x, y]] = score if score > 0
  }
}

puts trails.values.sum
