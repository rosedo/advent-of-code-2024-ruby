USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

corrupted_memory = PUZZLE

puts corrupted_memory.scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum { _1.to_i * _2.to_i }

split = corrupted_memory.split("don't()")
starting_disabled_sectors = split[1..-1]
enabled_corrupted_memory = split[0] + starting_disabled_sectors.map { _1.split("do()", 2)[1..-1].join }.join

puts enabled_corrupted_memory.scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum { _1.to_i * _2.to_i }

__END__

regex = /(mul\((\d{1,3}),(\d{1,3})\)|do[n't]*\(\))/
input.scan(regex).each do |instruction, a, b|
    if instruction == "do()"
        enabled = true
    elsif instruction == "don't()"
        enabled = false
    end
    sum += a.to_i * b.to_i if enabled
end
puts sum
