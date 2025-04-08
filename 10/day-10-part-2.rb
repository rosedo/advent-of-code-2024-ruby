USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

TOPO_MAP = PUZZLE.split(?\n).map { _1.split("").map(&:to_i) }
WIDTH = TOPO_MAP[0].size
HEIGHT = TOPO_MAP.size

def cell_at(x, y)
  return nil if x < 0 or x >= WIDTH or y < 0 or y >= HEIGHT
  return TOPO_MAP[y][x]
end

def tail_paths(x, y, path_beginning)
  return Set[] if cell_at(x, y) != path_beginning.size
  path = [*path_beginning, [x, y]]
  return Set[path] if path_beginning.size == 9
  paths = Set[]
  [[-1, 0], [1, 0], [0, -1], [0, 1]].each { |(delta_x, delta_y)|
    tail_paths(x + delta_x, y + delta_y, path).each { paths.add _1 }
  }
  return paths
end

trails = {}
TOPO_MAP.each_with_index { |row, y|
  row.each_with_index { |cell, x|
    rating = tail_paths(x, y, []).size
    trails[[x, y]] = rating if rating > 0
  }
}

puts trails.values.sum
