class Item
  attr_reader :name, :cost, :damage, :defense

  def initialize(name, cost, damage, defense)
    @name = name
    @cost = cost
    @damage = damage
    @defense = defense
  end
end

class Weapon < Item
end

class Armor < Item
end

class Ring < Item
end

class Character
  attr_reader :name, :equipment, :damage, :defense
  attr_accessor :hit_points

  def initialize(name, hit_points, options = {})
    @name = name
    @hit_points = hit_points
    @equipment = options[:equipment] || []
    @damage  = options[:damage]  || calculate_attack
    @defense = options[:defense] || calculate_absorb
  end

  def attack(target)
    result = self.damage - target.defense
    result = 1 if result < 1
    target.hit_points -= result
  end

  def duel_to_the_death(enemy)
    hero = self
    combatants = [hero, enemy]
    combatants.cycle do |character|
      character == hero ? target = enemy : target = hero
      return character if character.attack(target) <= 0
    end
  end

  private

    def calculate_attack
      equipment.inject(0) { |total, item| total += item.damage }
    end

    def calculate_absorb
      equipment.inject(0) { |total, item| total += item.defense }
    end
end

weapons = [
  Weapon.new("Dagger", 8, 4, 0),
  Weapon.new("Shortsword", 10, 5, 0),
  Weapon.new("Warhammer", 25, 6, 0),
  Weapon.new("Longsword", 40, 7, 0),
  Weapon.new("Greataxe", 74, 8, 0)
]

armor = [
  Armor.new("Bare", 0, 0, 0),
  Armor.new("Leather", 13, 0, 1),
  Armor.new("Chainmail", 31, 0, 2),
  Armor.new("Splintmail", 53, 0, 3),
  Armor.new("Bandedmail", 75, 0, 4),
  Armor.new("Platemail", 102, 0, 5)
]

rings = [
  Ring.new("Empty R", 0, 0, 0),
  Ring.new("Empty L", 0, 0, 0),
  Ring.new("Damage +1", 25, 1, 0),
  Ring.new("Damage +2", 50, 2, 0),
  Ring.new("Damage +3", 100, 3, 0),
  Ring.new("Defense +1", 20, 0, 1),
  Ring.new("Defense +2", 40, 0, 2),
  Ring.new("Defense +3", 80, 0, 3)
]

# Part One and Two
def find_cheapest_win_and_most_expensive_loss(weapons, armor, rings)
  winning_sets = []
  losing_sets  = []

  weapons.each do |w|
    armor.each do |a|
      rings.combination(2).to_a.each do |r|
        arms = [w, a, r].flatten
        hero = Character.new("Knowledge", 100, { equipment: arms })
        boss = Character.new("Ignorance", 103, { damage: 9, defense: 2})
        if hero.duel_to_the_death(boss) == hero
          winning_sets << arms
        else
          losing_sets << arms
        end
      end
    end
  end

  cheapest_set  = winning_sets.min_by { |set| set.inject(0) { |total, item| total += item.cost } }
  cheapest_cost = cheapest_set.inject(0) { |total, item| total += item.cost }
  puts "Cheapest win: #{cheapest_cost} GP with #{cheapest_set.map(&:name).join(", ")}"

  costliest_set  = losing_sets.max_by { |set| set.inject(0) { |total, item| total += item.cost } }
  costliest_cost = costliest_set.inject(0) { |total, item| total += item.cost }
  puts "Costliest loss: #{costliest_cost} GP with #{costliest_set.map(&:name).join(", ")}"
end

find_cheapest_win_and_most_expensive_loss(weapons, armor, rings)

### Other Approaches ###

# 1) Obviously, there is no need to simulate the battle turn-by-turn--all that's needed
#    is a comparison of the number of turns it takes the hero and boss to win, but
#    simulating battle is more reusable in case of future modifications like randomized
#    damage, etc.