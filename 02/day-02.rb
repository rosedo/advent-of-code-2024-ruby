USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

reports = PUZZLE.lines.map { _1.split(?\ ).map(&:to_i) }

def is_safe_without_the_problem_dampener(report)
  differences = report.each_cons(2).map { _2 - _1 }
  return (differences.all? &:positive? or differences.all? &:negative?) && differences.map(&:abs).all? { _1 <= 3 }
end

def is_safe(report)
  return true if is_safe_without_the_problem_dampener report
  report.each_index { |i|
    modified_report = report.dup.tap { _1.delete_at i }
    return true if is_safe_without_the_problem_dampener(modified_report)
  }
  return false
end

puts reports.select { is_safe_without_the_problem_dampener _1 }.size
puts reports.select { is_safe _1 }.size
