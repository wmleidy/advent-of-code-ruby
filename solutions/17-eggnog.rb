# --- Day 17: No Such Thing as Too Much ---

# The elves bought too much eggnog again - 150 liters this time. To fit it all into your refrigerator, you'll need to move it into smaller containers. You take an inventory of the capacities of the available containers.

# For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters, there are four ways to do it:

# 15 and 10
# 20 and 5 (the first 5)
# 20 and 5 (the second 5)
# 15, 5, and 5
# Filling all containers entirely, how many different combinations of containers can exactly fit all 150 liters of eggnog?

# --- Part Two ---

# While playing with all the containers in the kitchen, another load of eggnog arrives! The shipping and receiving department is requesting as many containers as you can spare.

# Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How many different ways can you fill that number of containers and still hold exactly 150 litres?

# In the example above, the minimum number of containers was two. There were three ways to use that many containers, and so the answer there would be 3.

# (Probably would have just missed the leaderboard had I started at 11 pm instead of 1:20 am.)

input = [50,44,11,49,42,46,18,32,26,40,21,7,18,43,10,47,36,24,22,40]

def subsets_with_combos(set, arr = [], set_element = [], all_subsets = [])
  if arr.length == set.length
    all_subsets << set_element.dup
  else
    [0, 1].each do |digit|
      set_element << set[arr.length] if digit == 1
      arr << digit
      subsets_with_combos(set, arr, set_element, all_subsets)
      arr.pop
      set_element.pop if digit == 1
    end
  end
  all_subsets
end

# Part One
def bottles_finder(subsets)
  subsets.select { |subset| subset.inject(0) { |sum, num| sum += num} == 150 }.count
end

p bottles_finder(subsets_with_combos(input))

# Part Two
def minimum_bottles_finder(subsets)
  all_valid_subsets = subsets.select { |subset| subset.inject(0) { |sum, num| sum += num} == 150 }
  min_length = all_valid_subsets.min_by { |subset| subset.length }.length
  min_subsets = all_valid_subsets.select { |subset| subset.length == min_length }.count
end

p minimum_bottles_finder(subsets_with_combos(input))

### Much more concise Ruby solution ###
# cs = [50, 44, 11, 49, 42, 46, 18, 32, 26, 40, 21, 7, 18, 43, 10, 47, 36, 24, 22, 40]

# solns = (1..cs.size).reduce([]) do |m, i|
#   m.concat(cs.combination(i).select {|x| x.inject(:+) == 150})
# end

# min = solns.map(&:size).min
# p solns.count {|x| x.size == min}

### Another Ruby magic solution ###
# containers = ARGF.readlines.map(&:to_i)

# # Part 1
# p (2..9).reduce(0){|sum, i| sum + containers.combination(i).find_all{|c| c.reduce(:+) == 150 }.length }

# # Part 2
# p containers.sort.combination(4).find_all{|c| c.reduce(:+) == 150 }.length