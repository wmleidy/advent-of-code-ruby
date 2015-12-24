# An n-partition problem...
present_weights = [1,3,5,11,13,17,19,23,29,31,37,41,43,47,53,59,67,71,73,79,83,89,97,101,103,107,109,113]

def passenger_seat_combos(arr, items, weight)
  valid_combos = []
  arr.combination(items).to_a.each do |combo|
    valid_combos << combo if combo.inject(:+) == weight
  end
  # return combos sorted by "quantum entanglement"
  valid_combos.sort_by { |combo| quantum_entanglement(combo) }
end

def quantum_entanglement(arr)
  arr.inject(:*)
end

def find_min_that_can_be_balanced(arr, combos, groups, weight)
  # because combos are already sorted by quantum entanglement in #passenger_seat_combos,
  # we can just return the first one we find that has remaining subsets capable of
  # being balanced properly
  combos.each do |combo|
    remaining = arr - combo
    if can_be_balanced?(remaining, groups, weight)
      return quantum_entanglement(combo)
    end
  end
  nil
end

def can_be_balanced?(arr, groups, weight)
  return true if groups == 1 && arr.inject(:+) == weight
  
  (1..(arr.length - 1)).to_a.each do |combo_size|
    arr.combination(combo_size).to_a.each do |combo|
      if combo.inject(:+) == weight
        remaining = arr - combo
        return can_be_balanced?(remaining, groups - 1, weight)
      end
    end
  end
  false
end

# Part One
# desired_weight = present_weights.inject(:+) / 3
# p desired_weight  # 508

# Since all present weights are odd, that means the minimum amount of packages
# we can put in the passenger seat is 6, so search for combinations of 6 that add up to 508

sorted_combos_3_partitions = passenger_seat_combos(present_weights, 6, 508)
p find_min_that_can_be_balanced(present_weights, sorted_combos_3_partitions, 2, 508)

# Part Two
# desired_weight = present_weights.inject(:+) / 4
# p desired_weight # 381

# Since all present weights are odd, that means the minimum amount of packages
# we can put in the passenger seat is now 5, so search for combinations of 5 that add up to 381

sorted_combos_4_partitions = passenger_seat_combos(present_weights, 5, 381)
p find_min_that_can_be_balanced(present_weights, sorted_combos_4_partitions, 3, 381)

### Notes ###

# Looking through the Day 24 subreddit, a lot of people came up with ways to find
# the smallest possible quantum entanglement that satisfies the desired weight.
# However, very few bothered to check whether the weights of the remaining presents
# could be divvied up properly among the other compartments to result in a
# perfectly balanced sleigh, instead relying on the AoC website to do this for 
# them. I took this shortcut too at first, but in my mind, this doesn't constitute
# a valid or complete solution to the problem.

# My methods #find_min_that_can_be_balanced and #can_be_balanced? can certainly
# be combined into one longer method as there is shared code, but I think the
# present implementation reads more clearly and divided up responsibilities
# better.

# That being said, there is certainly some additional refactoring that could be
# done to make both of the aforementioned methods cleaner.

### Other Approaches ###

# The group with the lowest possible quantum entanglement can also be found using:
# 1) Breadth-First Search
# 2) A greedy algorithm that starts with the largest weights (this is how I started)

# ...however, both of these approaches won't check whether the remaining subset can
# be properly balanced on the sleigh