USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip
CONNECTIONS_LIST = PUZZLE.split(?\n).map { _1.split(?-) }
CONNECTIONS = Hash.new { _1[_2] = Set[] }
CONNECTIONS_LIST.each { |(c1, c2)|
  CONNECTIONS[c1] << c2
  CONNECTIONS[c2] << c1
}
COMPUTERS = CONNECTIONS.keys
T_COMPUTERS = COMPUTERS.filter { _1[0] == ?t }
SETS = Set[]
CONNECTIONS_LIST.each { |(c1, c2)|
  COMPUTERS.each { |c3|
    next if [c1, c2].include?(c3)
    connections = CONNECTIONS[c3]
    next if ![c1, c2].all? { connections.include?(_1) }
    SETS << [c1, c2, c3].sort
  }
}

puts SETS.count { |set| T_COMPUTERS.find { set.include?(_1) } }

def just_bigger_sets(sets)
  result = Set[]
  sets.each { |set|
    COMPUTERS.each { |other|
      next if set.include?(other)
      connections = CONNECTIONS[other]
      next if !set.all? { connections.include?(_1) }
      result << [*set, other].sort
    }
  }
  return result
end

prev_sets = SETS
# i = 0
loop {
  #   p [i, prev_sets.size]
  #   i += 1
  sets = just_bigger_sets(prev_sets)
  if sets.empty?
    puts prev_sets.first.sort.join(?,)
    break
  end
  prev_sets = sets
}
