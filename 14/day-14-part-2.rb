USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

numbers = PUZZLE.split(?\n).map { _1.scan(/-?\d+/).map(&:to_i) }
WIDTH = [numbers.map { _1[0] }.max, numbers.map { _1[2] }.max].max + 1
HEIGHT = [numbers.map { _1[1] }.max, numbers.map { _1[3] }.max].max + 1

10000.times { |t|
  numbers.each_with_index { |position_velocity, index|
    p_x, p_y, v_x, v_y = *position_velocity
    p_x += v_x
    p_y += v_y
    p_x += WIDTH while p_x < 0
    p_y += HEIGHT while p_y < 0
    p_x -= WIDTH while p_x >= WIDTH
    p_y -= HEIGHT while p_y >= HEIGHT
    numbers[index] = [p_x, p_y, v_x, v_y]
  }
  lines = []
  HEIGHT.times { lines << ("-" * WIDTH) }
  numbers.each {
    p_x, p_y = *_1
    lines[p_y][p_x] = "+"
  }
  str = lines.join(?\n)
  if str.include?("+++++++++")
    # puts str
    puts t
    break
  end
}
