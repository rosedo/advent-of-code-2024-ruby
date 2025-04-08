USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

equations = {}
PUZZLE.lines.each { |equation_str|
  test_value_str, remaining_numbers_str = equation_str.split(":")
  test_value = test_value_str.to_i
  remaining_numbers = remaining_numbers_str.strip.split(" ").map(&:to_i)
  equations[test_value] = remaining_numbers
}

puts equations.select { |test_value, remaining_numbers|
  operators = [:+, :*]
  op_count = remaining_numbers.size - 1
  op_variants = (2 ** op_count).times.to_a.map {
    next _1.to_s(2).rjust(op_count, "0")
  }.map { |str|
    str.split("").map { operators[_1.to_i] }
  }
  next op_variants.any? { |variant|
         result = remaining_numbers[0]
         variant.each_with_index { |op, index| result = result.send(op, remaining_numbers[index + 1]) }
         next test_value == result
       }
}.keys.sum

puts equations.select { |test_value, remaining_numbers|
  operators = [:+, :*, :'||']
  op_count = remaining_numbers.size - 1
  op_variants = (3 ** op_count).times.to_a.map {
    next _1.to_s(3).rjust(op_count, "0")
  }.map { |str|
    str.split("").map {
      operators[_1.to_i]
    }
  }
  next op_variants.any? { |variant|
         result = remaining_numbers[0]
         variant.each_with_index { |op, index|
           result = if op == :'||'
               "#{result}#{remaining_numbers[index + 1]}".to_i
             else
               result.send(op, remaining_numbers[index + 1])
             end
         }
         next test_value == result
       }
}.keys.sum
