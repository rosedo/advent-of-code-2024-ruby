require "etc"
require "fileutils"

USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
SECRETS = PUZZLE.split(?\n).map(&:to_i)

def next_secret(secret)
  secret = ((secret * 64) ^ secret) % 16777216
  secret = ((secret / 32) ^ secret) % 16777216
  return ((secret * 2048) ^ secret) % 16777216
end

BUYERS_PRICES, BUYERS_PRICE_CHANGES, BUYERS_PRICE_CHANGES_STR, TEST_SEQUENCES = [], [], [], Set[]
if USE_EXAMPLE || !File.exist?("data/22/cache1.rb")
  SECRETS.each { |secret|
    buyer_prices, buyer_price_changes, buyer_price_changes_str = [secret % 10], [], ?,
    2000.times {
      secret = next_secret(secret)
      buyer_prices << secret % 10
      buyer_price_changes << buyer_prices[-1] - buyer_prices[-2]
      buyer_price_changes_str << "#{buyer_price_changes[-1]},"
    }
    BUYERS_PRICES << buyer_prices
    BUYERS_PRICE_CHANGES << buyer_price_changes
    BUYERS_PRICE_CHANGES_STR << buyer_price_changes_str
  }
  BUYERS_PRICE_CHANGES.each { |buyer_price_changes|
    buyer_price_changes.each_cons(4).each { TEST_SEQUENCES << ",#{_1.join(?,)}," }
  }
  unless USE_EXAMPLE
    FileUtils.mkdir_p("data/22")
    File.binwrite("data/22/cache1.rb", Marshal::dump([BUYERS_PRICES, BUYERS_PRICE_CHANGES, BUYERS_PRICE_CHANGES_STR, TEST_SEQUENCES]))
  end
else
  a, b, c, d = *Marshal::load(File.binread("data/22/cache1.rb"))
  BUYERS_PRICES.replace(a)
  BUYERS_PRICE_CHANGES.replace(b)
  BUYERS_PRICE_CHANGES_STR.replace(c)
  TEST_SEQUENCES.replace(d)
end

max = 0
# i = 0
BUYERS_SLICES = BUYERS_PRICE_CHANGES.map { _1.each_cons(4).to_a }
TEST_SEQUENCES.each { |sequence|
  # next if sequence != ",0,-1,-1,2,"
  seq = sequence[1..-2].split(?,).map(&:to_i)
  sum = 0
  BUYERS_PRICE_CHANGES_STR.each_with_index { |buyer_price_changes_str, index|
    if buyer_price_changes_str.index(sequence)
      first_index = BUYERS_SLICES[index].index(seq)
      sum += BUYERS_PRICES[index][first_index + 4] if first_index
    end
  }
  max = sum if sum > max
  # p [i, max] if i % 100 == 0
  # i += 1
}
puts max
