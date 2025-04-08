USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

ROTATION_SCORE = 1000
MOVE_FORWARD_SCORE = 1
grid = PUZZLE.split(?\n).map(&:chars)
nodes = []
start_tile = nil
end_tile = nil
direction_syms = [:north, :east, :south, :west]
grid.each_with_index { |row, y|
  row.each_with_index { |cell, x|
    next unless "SE.".include?(cell)
    if cell == ?S then start_tile = [x, y] elsif cell == ?E then end_tile = [x, y] end
    direction_syms.each { nodes << [x, y, _1] }
  }
}
exits = {}
directions = { north: [0, -1], east: [1, 0], south: [0, 1], west: [-1, 0] }
nodes.each { |node|
  x, y, direction = *node
  d_x, d_y = *directions[direction]
  h = {}
  [-1, 1].each { h[[x, y, direction_syms[(direction_syms.index(direction) + _1) % 4]]] = ROTATION_SCORE }
  h[[x + d_x, y + d_y, direction]] = MOVE_FORWARD_SCORE if "SE.".include?(grid[y + d_y][x + d_x])
  exits[node] = h
}
start_node = [*start_tile, :east]
end_nodes = direction_syms.map { [*end_tile, _1] }

def dijkstra(graph, start)
  # we don't need the prev_map since we're not using the get_path function (after __END__ below) for this but let's keep it anyway
  dist_map, visited, prev_map = {}, {}, {}
  nodes = graph.keys
  nodes.each { dist_map[_1] = Float::INFINITY }
  dist_map[start] = 0
  until nodes.empty?
    min_node = nodes.min_by { visited[_1] ? Float::INFINITY : dist_map[_1] }
    break if dist_map[min_node] == Float::INFINITY # is this line useful?
    graph[min_node].each { |neighbor, value|
      alt = dist_map[min_node] + value
      if alt < dist_map[neighbor]
        dist_map[neighbor] = alt
        prev_map[neighbor] = min_node
      end
    }
    visited[min_node] = true
    nodes.delete(min_node)
  end
  return [dist_map, prev_map]
end

dist_map, prev_map = *dijkstra(exits, start_node)

puts end_nodes.map { dist_map[_1] }.min

__END__

# https://blog.stackademic.com/dijkstras-shortest-path-algorithm-in-ruby-951417829173
# https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

def get_path(prev_map, src, dest)
    s = []
    u = dest
    if prev_map[u] || u == src
        while u
            s.insert(0, u)
            u = prev_map[u]
        end
    end
    return s
end

p get_path(prev_map, start_node, end_nodes[0]).reverse
