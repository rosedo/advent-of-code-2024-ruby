require "matrix"

USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

grid = PUZZLE.lines.map { _1.strip.split "" }

DIRECTIONS = {
  ?^ => [0, -1], # the y axis goes down in our grid
  ?> => [1, 0],
  ?v => [0, 1],
  ?< => [-1, 0],
}

def find_guard_position(grid)
  grid.each_with_index { |row, y|
    row.each_with_index { |cell, x|
      return [x, y] if DIRECTIONS[cell]
    }
  }
end

def char_at(grid, position)
  return nil unless position[0] >= 0 and position[1] >= 0
  return grid[position[1]] ? grid[position[1]][position[0]] : nil
end

initial_guard_position = find_guard_position(grid)
initial_guard_direction = DIRECTIONS[char_at(grid, initial_guard_position)]

def obstruction_at?(grid, position)
  return char_at(grid, position) == ?#
end

def front_position(guard_position, guard_direction)
  [
    guard_position[0] + guard_direction[0],
    guard_position[1] + guard_direction[1],
  ]
end

guard_position = initial_guard_position
guard_direction = initial_guard_direction
visited_positions = Set[[*guard_position]]
loop do
  front = front_position(guard_position, guard_direction)
  break unless char_at(grid, front)
  if obstruction_at?(grid, front)
    guard_direction = [-guard_direction[1], guard_direction[0]] # 90° clockwise rotation
    front = front_position(guard_position, guard_direction)
  end
  guard_position = front
  visited_positions << [*guard_position]
end

puts visited_positions.size

result = 0

visited_positions.dup.each { |(x, y)|
  cell = char_at(grid, [x, y])
  # p [x, y]
  next if cell == ?# || [x, y] == initial_guard_position
  grid[y][x] = ?#

  # testing grid with new obstacle
  guard_position = initial_guard_position
  guard_direction = initial_guard_direction
  visited_positions = [[*guard_position, *guard_direction]]
  loop do
    front = front_position(guard_position, guard_direction)
    break unless char_at(grid, front)
    if obstruction_at?(grid, front)
      guard_direction = [-guard_direction[1], guard_direction[0]] # 90° clockwise rotation
      front = front_position(guard_position, guard_direction)
      if obstruction_at?(grid, front)
        guard_direction = [-guard_direction[1], guard_direction[0]] # 90° clockwise rotation
        front = front_position(guard_position, guard_direction)
      end
    end
    guard_position = front
    visiting = [*guard_position, *guard_direction]
    if visited_positions.include?(visiting)
      result += 1 # guard is in a loop
      break
    end
    visited_positions << visiting
  end

  grid[y][x] = cell
}

puts result
