# Recursive subset finder using an ersatz on/off approach (emulates bit manipulation)
# that I wrote while doing practice whiteboard problems
def get_subsets(set, arr = [], set_element = [], all_subsets = [])
  if arr.length == set.length
    all_subsets << set_element.dup
  else
    [0, 1].each do |digit|
      set_element << set[arr.length] if digit == 1
      arr << digit
      get_subsets(set, arr, set_element, all_subsets)
      arr.pop
      set_element.pop if digit == 1
    end
  end
  all_subsets
end

# Part One
def valid_bottle_combos(subsets)
  # subtract out empty set in order to use #inject(:+) shorthand
  (subsets - []).select { |subset| subset.inject(:+) == 150 }
end

input = [50,44,11,49,42,46,18,32,26,40,21,7,18,43,10,47,36,24,22,40]
p valid_bottle_combos(get_subsets(input)).count

# Part Two
def minimum_bottle_combos_finder(subsets)
  all_valid_combos = valid_bottle_combos(subsets)
  min_length = all_valid_combos.min_by { |combo| combo.length }.length
  all_valid_combos.select { |subset| subset.length == min_length }
end

p minimum_bottle_combos_finder(get_subsets(input)).count

### Other Approaches ###
# Two neat and complete Ruby solutions are below...
# 1) 
  # cs = [50, 44, 11, 49, 42, 46, 18, 32, 26, 40, 21, 7, 18, 43, 10, 47, 36, 24, 22, 40]

  # solns = (1..cs.size).reduce([]) do |m, i|
  #   m.concat(cs.combination(i).select {|x| x.inject(:+) == 150})
  # end

  # min = solns.map(&:size).min
  # p solns.count {|x| x.size == min}

# 2)
  # containers = ARGF.readlines.map(&:to_i)

  # # Part 1
  # p (2..9).reduce(0){|sum, i| sum + containers.combination(i).find_all{|c| c.reduce(:+) == 150 }.length }

  # # Part 2
  # p containers.sort.combination(4).find_all{|c| c.reduce(:+) == 150 }.length