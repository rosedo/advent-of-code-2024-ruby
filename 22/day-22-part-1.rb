USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
SECRETS = PUZZLE.split(?\n).map(&:to_i)

def next_secret(secret)
  secret = ((secret * 64) ^ secret) % 16777216
  secret = ((secret / 32) ^ secret) % 16777216
  return ((secret * 2048) ^ secret) % 16777216
end

puts SECRETS.sum { |secret|
  2000.times { secret = next_secret(secret) }
  next secret
}
