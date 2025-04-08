require "fileutils"
require "json"

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

# score of the optimal paths
PART_1_ANSWER = USE_EXAMPLE ? 7036 : 114476 # using the example input, we have 416 nodes

if USE_EXAMPLE
  dist_map, prev_map = *dijkstra(exits, start_node)
else
  unless File.exist?("data/16/dist_map.rb")
    dist_map, prev_map = *dijkstra(exits, start_node)
    FileUtils.mkdir_p("data/16")
    File.binwrite("data/16/dist_map.rb", Marshal::dump(dist_map))
    File.binwrite("data/16/prev_map.rb", Marshal::dump(prev_map))
  else
    dist_map, prev_map = Marshal::load(File.binread("data/16/dist_map.rb")), Marshal::load(File.binread("data/16/prev_map.rb"))
  end
end

def find_all_paths(dist_map, g, src, dst, result = [], stack = [], stack_scores = [])
  return if stack_scores.sum > (dist_map[stack.last] || 0)
  g[src].each { |exit, score|
    next if stack.include?(exit)
    if exit == dst
      result << stack.dup if stack_scores.sum == PART_1_ANSWER
    elsif !result.include?(exit)
      stack << exit
      stack_scores << score
      find_all_paths(dist_map, g, exit, dst, result, stack, stack_scores)
      stack.pop
      stack_scores.pop
    end
  }
end

def extract_chairs(result, end_nodes)
  chairs = result.flatten(1).map { |(x, y)| [x, y] }
  chairs << [end_nodes[0][0], end_nodes[0][1]]
  return chairs.uniq
end

chairs = []
end_nodes.each { |end_node|
  result = []
  find_all_paths(dist_map, exits, start_node, end_nodes[0], result)
  chairs_for_end_node = extract_chairs(result, end_nodes)
  chairs_for_end_node << [start_node[0], start_node[1]]
  chairs_for_end_node.each { chairs << _1 }
  break
  # p chairs_for_end_node.size
  # chairs_for_end_node.each {|(x, y)| grid[y][x] = 'O'}
  # grid.each { puts _1.join('') }
}
chairs.uniq!
chairs.each { |(x, y)| grid[y][x] = "O" }
# grid.each { puts _1.join("") }
puts chairs.size
