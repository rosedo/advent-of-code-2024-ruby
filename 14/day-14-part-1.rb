USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

numbers = PUZZLE.split(?\n).map { _1.scan(/-?\d+/).map(&:to_i) }
WIDTH = [numbers.map { _1[0] }.max, numbers.map { _1[2] }.max].max + 1
HEIGHT = [numbers.map { _1[1] }.max, numbers.map { _1[3] }.max].max + 1

numbers.each_with_index { |position_velocity, index|
  p_x, p_y, v_x, v_y = *position_velocity
  100.times {
    p_x += v_x
    p_y += v_y
    p_x += WIDTH while p_x < 0
    p_y += HEIGHT while p_y < 0
    p_x -= WIDTH while p_x >= WIDTH
    p_y -= HEIGHT while p_y >= HEIGHT
  }
  numbers[index] = [p_x, p_y, v_x, v_y]
}

top_left_quandrant_count = 0
top_right_quandrant_count = 0
bottom_left_quandrant_count = 0
bottom_right_quandrant_count = 0
quadrant_width = WIDTH / 2
quadrant_height = HEIGHT / 2
numbers.each {
  p_x, p_y = *_1
  top_left_quandrant_count += 1 if p_x < quadrant_width && p_y < quadrant_height
  top_right_quandrant_count += 1 if p_x >= WIDTH - quadrant_width && p_y < quadrant_height
  bottom_left_quandrant_count += 1 if p_x < quadrant_width && p_y >= HEIGHT - quadrant_height
  bottom_right_quandrant_count += 1 if p_x >= WIDTH - quadrant_width && p_y >= HEIGHT - quadrant_height
}

puts top_left_quandrant_count * top_right_quandrant_count * bottom_left_quandrant_count * bottom_right_quandrant_count
