# --- Day 15: Science for Hungry People ---

# Today, you set out on the task of perfecting your milk-dunking cookie recipe. All you have to do is find the right balance of ingredients.

# Your recipe leaves room for exactly 100 teaspoons of ingredients. You make a list of the remaining ingredients you could use to finish the recipe (your puzzle input) and their properties per teaspoon:

# capacity (how well it helps the cookie absorb milk)
# durability (how well it keeps the cookie intact when full of milk)
# flavor (how tasty it makes the cookie)
# texture (how it improves the feel of the cookie)
# calories (how many calories it adds to the cookie)
# You can only measure ingredients in whole-teaspoon amounts accurately, and you have to be accurate so you can reproduce your results in the future. The total score of a cookie can be found by adding up each of the properties (negative totals become 0) and then multiplying together everything except calories.

# For instance, suppose you have these two ingredients:

# Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
# Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
# Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of cinnamon (because the amounts of each ingredient must add up to 100) would result in a cookie with the following properties:

# A capacity of 44*-1 + 56*2 = 68
# A durability of 44*-2 + 56*3 = 80
# A flavor of 44*6 + 56*-2 = 152
# A texture of 44*3 + 56*-1 = 76
# Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results in a total score of 62842880, which happens to be the best score possible given these ingredients. If any properties had produced a negative total, it would have instead become zero, causing the whole score to multiply to zero.

# Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie you can make?

# --- Part Two ---

# Your cookie recipe becomes wildly popular! Someone asks if you can make another recipe that has exactly 500 calories per cookie (so they can use it as a meal replacement). Keep the rest of your award-winning process the same (100 teaspoons, same ingredients, same scoring system).

# For example, given the ingredients above, if you had instead selected 40 teaspoons of butterscotch and 60 teaspoons of cinnamon (which still adds to 100), the total calorie count would be 40*8 + 60*3 = 500. The total score would go down, though: only 57600000, the best you can do in such trying circumstances.

# Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie you can make with a calorie total of 500?

# Sprinkles: capacity 2, durability 0, flavor -2, texture 0, calories 3
# Butterscotch: capacity 0, durability 5, flavor -3, texture 0, calories 3
# Chocolate: capacity 0, durability 0, flavor 5, texture -1, calories 8
# Candy: capacity 0, durability -1, flavor 0, texture 5, calories 8

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

def possible_proportions
  arr = Array.new(4, 0)
  proportions = []
  (0..100).to_a.each do |index0|
    arr[0] = index0
    (0..100).to_a.each do |index1|
      arr[1] = index1
      (0..100).to_a.each do |index2|
        arr[2] = index2
        (0..100).to_a.each do |index3|
          arr[3] = index3
          if arr.inject(:+) == 100
            proportions << arr.dup
          end
        end
      end
    end
  end
  proportions
end

def find_mix(combos, list)
  max_goodness = 0
  best_mix = nil
  combos.each do |combo|
    # p combo
    mix = []
    combo[0].times { mix << list[0] }
    combo[1].times { mix << list[1] }
    combo[2].times { mix << list[2] }
    combo[3].times { mix << list[3] }
    goodness = calculate_goodness(mix)
    if goodness > max_goodness
      max_goodness = goodness
      best_mix = combo.dup
      p max_goodness
    end
  end
  p [max_goodness, best_mix]
end

def calculate_goodness(ingredients)
  arr = Array.new(5, 0)
  ingredients.each do |ingred|
    arr[0] += ingred.capacity
    arr[1] += ingred.durability
    arr[2] += ingred.flavor
    arr[3] += ingred.texture
    arr[4] += ingred.calories # for Part Two
  end
  if arr.all? { |stat| stat > 0 } && arr[4] == 500 # second part for Part Two
    arr[0..3].inject(1) { |sum, num| sum *= num }
  else
    0
  end
end

ingredient_list = [Ingredient.new("Sprinkles", 2, 0, -2, 0, 3),
                   Ingredient.new("Butterscotch", 0, 5, -3, 0, 3),
                   Ingredient.new("Chocolate", 0, 0, 5, -1, 8),
                   Ingredient.new("Candy", 0, -1, 0, 5, 8)]
# p find_mix(possible_proportions, ingredient_list)
# Answer: [21367368, [17, 19, 38, 26]] Part One
# Answer: [1766400, [46, 14, 30, 10]] Part Two

### This speeds it up A LOT--thanks Reddit ###

# def possible_proportions
#   arr = Array.new(4, 0)
#   proportions = []
#   (0..100).to_a.each do |index0|
#     arr[0] = index0
#     (0..100 - index0).to_a.each do |index1|
#       arr[1] = index1
#       (0..100 - index0 - index1).to_a.each do |index2|
#         arr[2] = index2
#         arr[3] = 100 - index0 - index1 - index2
#         proportions << arr.dup
#       end
#     end
#   end
#   proportions
# end

### A verbose Ruby solution perhaps worth analyzing ###

# class Ingredient
#   def initialize(name)
#     @name = name
#     @capacity = 0
#     @durability = 0
#     @flavor = 0
#     @texture = 0
#     @calories = 0
#   end
# end

# def get_sum_possibilities(numbers, sum)
#   Array(numbers).repeated_combination(4).find_all { |x, y, z, a| x + y +z + a == sum } || []
# end

# def generate_cookie_score(cookie_map, part2)
#   capacity = 0
#   durability = 0
#   flavor = 0
#   texture = 0
#   calories = 0
#   result = 0
#   cookie_map.each_pair do |key, value|
#     capa = key.instance_variable_get(:@capacity) * value
#     capacity += capa

#     dura = key.instance_variable_get(:@durability) * value
#     durability += dura

#     flav = key.instance_variable_get(:@flavor) * value
#     flavor += flav

#     textu = key.instance_variable_get(:@texture) * value
#     texture += textu

#     calo = key.instance_variable_get(:@calories) * value
#     calories += calo
#   end
#   if capacity >= 0 && durability >=0 && flavor >=0 && texture >=0
#     result = capacity * durability * flavor * texture
#   end
#   if calories != 500 && part2
#     result = 0
#   end
#   result
# end

# File.open("#{File.dirname(__FILE__)}/input") do |file|
#   ingredients = file.readlines
#   cookie_map = Hash.new
#   ingredients.each do |ingredient|
#     split = ingredient.split(':')
#     ingredient = Ingredient.new(split[0])
#     ingredient_split = split[1].split(',')

#     ingredient.instance_variable_set(:@capacity, ingredient_split[0].scan(/-?\d+/).first.to_i)
#     ingredient.instance_variable_set(:@durability, ingredient_split[1].scan(/-?\d+/).first.to_i)
#     ingredient.instance_variable_set(:@flavor, ingredient_split[2].scan(/-?\d+/).first.to_i)
#     ingredient.instance_variable_set(:@texture, ingredient_split[3].scan(/-?\d+/).first.to_i)
#     ingredient.instance_variable_set(:@calories, ingredient_split[4].scan(/-?\d+/).first.to_i)
#     cookie_map[ingredient] = 0
#   end

#   teaspoons = Array(0..100)
#   score_list_part1 =[]
#   score_list_part2 =[]
#   combinations = get_sum_possibilities(teaspoons, 100)

#   combinations.each do |combination|
#     combination.permutation do |permutation|
#       index = 0
#       cookie_map.each_key do |key|
#         cookie_map[key] = permutation[index]
#         index +=1
#       end
#       #Part 1
#       cookie_score = generate_cookie_score(cookie_map, false)
#       score_list_part1 << cookie_score if cookie_score != 0
#       #Part 2
#       cookie_score = generate_cookie_score(cookie_map, true)
#       score_list_part2 << cookie_score if cookie_score != 0
#     end
#   end

#   puts "Part1: #{score_list_part1.max}"
#   puts "Part2: #{score_list_part2.max}"
# end