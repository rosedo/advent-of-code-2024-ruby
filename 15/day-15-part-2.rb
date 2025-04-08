USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

warehouse_str, movements_str = *PUZZLE.split(?\n * 2)
warehouse_str.gsub! ?#, "##"
warehouse_str.gsub! ?O, "[]"
warehouse_str.gsub! ?., ".."
warehouse_str.gsub! ?@, "@."

class RobotBlockedException < Exception
end

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

# WAREHOUSE.each { puts _1.join("") }

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

def boxes_parts_to_move(contact_box_x, contact_box_y, d_x, d_y)
  contact_box_cell = cell_at(contact_box_x, contact_box_y)
  other_part_x = contact_box_x + (contact_box_cell == "[" ? 1 : -1)
  result = Set[]
  result << [contact_box_x, contact_box_y]
  result << [other_part_x, contact_box_y]
  left_x = contact_box_cell == "[" ? contact_box_x : other_part_x
  right_x = contact_box_cell == "]" ? contact_box_x : other_part_x
  next_boxes_parts = []
  next_boxes_parts << [left_x - 1, contact_box_y] if d_x == -1
  next_boxes_parts << [right_x + 1, contact_box_y] if d_x == 1
  next_boxes_parts.push([contact_box_x, contact_box_y + d_y], [other_part_x, contact_box_y + d_y]) if d_y.abs == 1
  next_boxes_parts.each { raise RobotBlockedException if cell_at(*_1) == ?# }
  next_boxes_parts.select! { "[]".include?(cell_at(*_1)) }
  next_boxes_parts.each { |(x, y)|
    boxes_parts_to_move(x, y, d_x, d_y).each { result << _1 }
  }
  return result
end

def try_move_boxes(contact_box_x, contact_box_y, d_x, d_y)
  parts_to_move = nil
  begin
    parts_to_move = boxes_parts_to_move(contact_box_x, contact_box_y, d_x, d_y)
  rescue RobotBlockedException
    return false
  end
  parts_to_move = parts_to_move.sort { |(x1, y1), (x2, y2)| (x2 - x1) * d_x + (y2 - y1) * d_y }
  parts_to_move.each { |(x, y)|
    cell = cell_at(x, y)
    WAREHOUSE[y + d_y][x + d_x] = cell
    WAREHOUSE[y][x] = ?.
  }
  return true
end

MOVEMENTS.each { |movement|
  d_x, d_y = *MOV_MAP[movement]
  front_x, front_y = r_x + d_x, r_y + d_y
  front_cell = cell_at(front_x, front_y)
  next if front_cell == ?#
  if !"[]".include?(front_cell) || try_move_boxes(front_x, front_y, d_x, d_y)
    WAREHOUSE[r_y][r_x] = ?.
    r_x, r_y = front_x, front_y
    WAREHOUSE[r_y][r_x] = ?@
  end
}

# WAREHOUSE.each { puts _1.join("") }

boxes_lefts = []
WAREHOUSE.each_with_index { |row, y|
  row.each_with_index { |cell, x|
    boxes_lefts << [x, y] if cell == "["
  }
}

puts boxes_lefts.map { _1[0] + _1[1] * 100 }.sum
