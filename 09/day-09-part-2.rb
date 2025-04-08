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

disk_map.size.times.reverse_each { |file_id|
  file_size = disk_map[file_id][0]
  free_space_found = 0
  blocks.each_with_index { |block, index|
    break if block == file_id
    free_space_found = block ? 0 : free_space_found + 1
    if free_space_found == file_size
      file_size.times {
        blocks[blocks.rindex(file_id)] = nil
        blocks[index] = file_id
        index -= 1
      }
      blocks.pop until blocks.last
      break
    end
  }
}

checksum = 0
blocks.each_with_index { |file_id, index|
  checksum += index * file_id if file_id
}

puts checksum
