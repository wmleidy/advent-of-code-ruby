class Ingredient
  attr_reader :capacity, :durability, :flavor, :texture, :calories

  def initialize(name, capacity, durability, flavor, texture, calories)
    @name = name
    @capacity = capacity
    @durability = durability
    @flavor = flavor 
    @texture = texture
    @calories = calories
  end
end

# Refactored from "dumb" loops of 0..100 thanks to Reddit contributors
def possible_proportions
  arr = Array.new(4, 0)
  proportions = []
  (0..100).to_a.each do |index0|
    arr[0] = index0
    (0..100 - index0).to_a.each do |index1|
      arr[1] = index1
      (0..100 - index0 - index1).to_a.each do |index2|
        arr[2] = index2
        arr[3] = 100 - index0 - index1 - index2
        proportions << arr.dup
      end
    end
  end
  proportions
end

def find_mix(combos, list)
  max_goodness = 0
  best_mix = nil
  combos.each do |combo|
    mix = []
    combo[0].times { mix << list[0] }
    combo[1].times { mix << list[1] }
    combo[2].times { mix << list[2] }
    combo[3].times { mix << list[3] }
    goodness = calculate_goodness(mix)
    if goodness > max_goodness
      max_goodness = goodness
      best_mix = combo
      p max_goodness  # Useful progress tracker...
    end
  end
  [max_goodness, best_mix]
end

def calculate_goodness(ingredients)
  arr = Array.new(5, 0)
  ingredients.each do |ingredient|
    arr[0] += ingredient.capacity
    arr[1] += ingredient.durability
    arr[2] += ingredient.flavor
    arr[3] += ingredient.texture
    arr[4] += ingredient.calories # for Part Two
  end
  if arr.all? { |stat| stat > 0 } #&& arr[4] == 500 # put a # before && for Part One
    arr[0..3].inject(:*)
  else
    0
  end
end

ingredient_list = [Ingredient.new("Sprinkles", 2, 0, -2, 0, 3),
                   Ingredient.new("Butterscotch", 0, 5, -3, 0, 3),
                   Ingredient.new("Chocolate", 0, 0, 5, -1, 8),
                   Ingredient.new("Candy", 0, -1, 0, 5, 8)]

p find_mix(possible_proportions, ingredient_list)
# Answer: [21367368, [17, 19, 38, 26]] Part One
# Answer: [1766400, [46, 14, 30, 10]] Part Two

### Other Approaches ###
# 1) My favorite thing I saw on the Reddit debriefing was a very interesting way
#    to generate the sums that add up to 100 without resorting to a brute force
#    nested loop...

  # def get_sum_possibilities(numbers, sum)
  #   Array(numbers).repeated_combination(4).find_all { |x, y, z, a| x + y +z + a == sum } || []
  # end

  # ...then get_sum_possibilities(Array(0..100), 100) will return all valid combinations,
  # which can then individually be permuted (4! ways) using the #permutation Enumerator