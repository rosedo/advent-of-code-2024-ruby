USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
MAP = PUZZLE.split(?\n).map(&:chars)
DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]]
TRACK_RE = /^[S.E]$/
CHEAT_SIZE_LIMITS = [2, 20] # part 1, part 2
MIN_ECONOMY = 100

PATH = []
MAP.each_with_index { |row, y|
  x = row.find_index { _1 == ?S }
  if x
    PATH << [x, y]
    break
  end
}
loop {
  x, y = PATH[-1]
  prev_x, prev_y = PATH[-2]
  dx, dy = DIRECTIONS.find { |(dx, dy)| [x + dx, y + dy] != [prev_x, prev_y] && MAP[y + dy][x + dx] =~ TRACK_RE }
  break unless dx
  PATH << [x + dx, y + dy]
}

STD_TIME = PATH.size - 1

CHEAT_SIZE_LIMITS.each { |cheat_size_limit|
  valid_cheats_with_min_economy = 0
  PATH.each_with_index { |(x1, y1), i1|
    PATH.each_with_index { |(x2, y2), i2|
      next if i2 < i1 + 2
      cheat_size = (x2 - x1).abs + (y2 - y1).abs
      next unless cheat_size <= cheat_size_limit
      economy = i2 - i1 - cheat_size
      # next if economy.zero?
      next if economy < MIN_ECONOMY
      valid_cheats_with_min_economy += 1
    }
  }
  puts valid_cheats_with_min_economy
}
