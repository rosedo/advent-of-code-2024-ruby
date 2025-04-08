USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

warehouse_str, movements_str = *PUZZLE.split(?\n * 2)
WAREHOUSE = warehouse_str.split(?\n).map(&:chars)
WIDTH = WAREHOUSE[0].size
HEIGHT = WAREHOUSE.size
MOVEMENTS = movements_str.delete(?\n).split("")
MOV_MAP = {
  ?^ => [0, -1],
  ?> => [1, 0],
  ?< => [-1, 0],
  ?v => [0, 1],
}

def cell_at(x, y)
  return nil if x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT
  return WAREHOUSE[y][x]
end

r_x, r_y = nil, nil
WAREHOUSE.each_with_index { |row, y|
  row.each_with_index { |cell, x|
    r_x, r_y = x, y if cell == ?@
  }
}

MOVEMENTS.each { |movement|
  d_x, d_y = *MOV_MAP[movement]
  front_x, front_y = r_x + d_x, r_y + d_y
  front_cell = cell_at(front_x, front_y)
  next if front_cell == ?#
  if front_cell != ?O
    WAREHOUSE[r_y][r_x] = ?.
    r_x, r_y = front_x, front_y
    WAREHOUSE[r_y][r_x] = ?@
    next
  end
  boxes_count = 0
  curr_x, curr_y = front_x, front_y
  curr_cell = front_cell
  while curr_cell == ?O
    boxes_count += 1
    curr_x, curr_y = curr_x + d_x, curr_y + d_y
    curr_cell = cell_at(curr_x, curr_y)
  end
  next if curr_cell == ?#
  WAREHOUSE[r_y][r_x] = ?.
  r_x, r_y = front_x, front_y
  WAREHOUSE[r_y][r_x] = ?@
  boxes_count.times { |t|
    WAREHOUSE[front_y + d_y * (t + 1)][front_x + d_x * (t + 1)] = ?O
  }
}

# WAREHOUSE.each { puts _1.join("") }

boxes = []
WAREHOUSE.each_with_index { |row, y|
  row.each_with_index { |cell, x|
    boxes << [x, y] if cell == ?O
  }
}

puts boxes.map { _1[0] + _1[1] * 100 }.sum
