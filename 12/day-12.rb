USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

GARDEN = PUZZLE.split(?\n).map(&:chars)
WIDTH = GARDEN[0].size
HEIGHT = GARDEN.size

def opt_letter_at(x, y)
  return nil if x < 0 or y < 0 or x >= WIDTH or y >= HEIGHT
  return GARDEN[y][x]
end

regions = []
GARDEN.each_with_index { |row, y|
  row.each_index { |x|
    regions << [[x, y]]
  }
}

loop {
  found = 0
  regions.each_with_index { |region, index|
    next if region.nil?
    cell = opt_letter_at(*region[0])
    neighbors = region.map { |(x, y)|
      next [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]]
    }
    neighbors.flatten!(1)
    neighbors.select! { |(x, y)|
      next opt_letter_at(x, y) == cell && !region.include?([x, y])
    }
    neighbors.each { |neighbor|
      index2 = regions.find_index { _1 && _1.index(neighbor) }
      next if index2 == index
      found += 1
      region2 = regions[index2]
      regions[index2] = nil
      region.push(*region2)
    }
  }
  regions.reject!(&:nil?)
  break if found.zero?
  # puts regions.size
}

puts regions.map { |region|
  region_area = region.size
  region_perimeter = 0
  region.each { |(x, y)|
    letter = opt_letter_at(x, y)
    [[0, -1], [1, 0], [0, 1], [-1, 0]].each { |(delta_x, delta_y)|
      region_perimeter += 1 if opt_letter_at(x + delta_x, y + delta_y) != letter
    }
  }
  region_fence_price = region_area * region_perimeter
  next region_fence_price
}.sum.to_s

puts regions.map { |region|
  region_area = region.size
  fences = [:north, :east, :south, :west].map { [_1, []] }.to_h
  region.each { |(x, y)|
    letter = opt_letter_at(x, y)
    fences[:north] << [x, y] if opt_letter_at(x, y - 1) != letter
    fences[:east] << [x, y] if opt_letter_at(x + 1, y) != letter
    fences[:south] << [x, y] if opt_letter_at(x, y + 1) != letter
    fences[:west] << [x, y] if opt_letter_at(x - 1, y) != letter
  }
  region_perimeter = fences.values.flatten(1).size # same as part 1 perimeter
  fences.each { |direction, direction_fences|
    direction_fences.each { |(x, y)|
      region_perimeter -= direction_fences.select { |(x2, y2)|
        next ([:north, :south].include?(direction) && (x2 - x).abs == 1 && (y2 - y).abs.zero?) || ([:east, :west].include?(direction) && (y2 - y).abs == 1 && (x2 - x).abs.zero?)
      }.size / 2.0
    }
  }
  next region_area * region_perimeter.to_i
}.sum.to_s
