USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
tmp = PUZZLE.split(?\n * 2)
LOCKS = tmp.select { _1.start_with?(?#) }
KEYS = tmp - LOCKS

def test(lock, key)
  lock.split("").each_with_index { |char, index| return false if char == ?# && key[index] == ?# }
  return true
end

puts LOCKS.sum { |lock| KEYS.sum { |key| test(lock, key) ? 1 : 0 } }
