USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

disk_map = PUZZLE.scan(/\d{2}/).map { _1.split("").map(&:to_i) }
if PUZZLE.size % 2 == 1
  disk_map << [PUZZLE[-1].to_i, 0]
end

blocks = []
disk_map.each_with_index { |(file_blocks_count, free_space_blocks_count), file_id|
  file_blocks_count.times { blocks << file_id }
  free_space_blocks_count.times { blocks << nil }
}
blocks.pop until blocks.last

blocks.each_index { |index|
  next if blocks[index]
  blocks[index] = blocks.pop
  blocks.pop until blocks.last
}

checksum = 0
blocks.each_with_index { |file_id, index|
  checksum += index * file_id
}

puts checksum
