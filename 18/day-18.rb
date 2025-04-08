USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

FALLING_BYTES = PUZZLE.split(?\n).map { _1.split(",").map(&:to_i) }
IS_EXAMPLE = FALLING_BYTES.size == 25
SIZE = IS_EXAMPLE ? 7 : 71
first_k = IS_EXAMPLE ? 12 : 1024

def get_nodes(bytes)
  nodes = []
  SIZE.times { |x|
    SIZE.times { |y|
      node = [x, y]
      nodes << node unless bytes.include?(node)
    }
  }
  return nodes
end

def dijkstra(graph, start)
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

def get_path_size(falling_bytes_limit)
  start_node = [0, 0]
  end_node = [SIZE - 1] * 2
  exits = {}
  directions = { up: [0, -1], right: [1, 0], down: [0, 1], left: [-1, 0] }
  nodes = get_nodes(FALLING_BYTES[0, falling_bytes_limit])
  nodes.each { |node|
    x, y = *node
    h = {}
    directions.values.each { |(d_x, d_y)|
      exit_node = [x + d_x, y + d_y]
      h[exit_node] = 1 if nodes.include?(exit_node)
    }
    exits[node] = h
  }
  dist_map, prev_map = *dijkstra(exits, start_node)
  path = get_path(prev_map, start_node, end_node)
  return path.size == 0 ? nil : path.size - 1
end

puts get_path_size(first_k)

def find_limit_destructing_path_rec(search_min, search_max)
  # p [search_min, search_max]
  search_size = search_max - search_min + 1
  half_size = (search_size / 2.0).ceil
  half_upper_limit = search_min + half_size - 1
  middle_result = get_path_size(half_upper_limit)
  if middle_result.nil?
    return half_upper_limit == search_min ? search_min : find_limit_destructing_path_rec(search_min, half_upper_limit)
  end
  return find_limit_destructing_path_rec(half_upper_limit + 1, search_max)
end

min_known_ko_limit = find_limit_destructing_path_rec(first_k + 1, FALLING_BYTES.size)
puts FALLING_BYTES[min_known_ko_limit - 1].join(",")
