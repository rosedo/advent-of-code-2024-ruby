USE_EXAMPLE = false
PUZZLE = File.read(Dir["#{File.dirname(__FILE__)}/day-??#{USE_EXAMPLE ? "-example" : ""}-input.txt"].first).strip

page_ordering_rules_str, page_lists_str = *PUZZLE.split(?\n * 2)
page_ordering_rules = page_ordering_rules_str.lines.map { _1.strip.split("|").map(&:to_i) }
page_lists = page_lists_str.lines.map { _1.strip.split(",").map(&:to_i) }
sorted_page_lists = page_lists.map { |pages|
  pages.sort { |a, b| if page_ordering_rules.include?([a, b]) then -1 elsif page_ordering_rules.include?([b, a]) then 1 else 0 end }
}
puts sorted_page_lists.zip(page_lists).filter { |(list1, list2)| list1 == list2 }.map(&:first).map { |list1| list1[list1.length / 2] }.sum
puts sorted_page_lists.zip(page_lists).filter { |(list1, list2)| list1 != list2 }.map(&:first).map { |list1| list1[list1.length / 2] }.sum
