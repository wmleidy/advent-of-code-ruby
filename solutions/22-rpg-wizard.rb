class Spell
  attr_accessor :mp_required, :duration, :turns_remaining, :caster, :target
end

class MagicMissile < Spell

  def initialize(target)
    @mp_required = 53
    @duration = 1
    @turns_remaining = duration
    @target = target
  end

  def effect
    target.hp -= 4
  end
end

class Drain < Spell

  def initialize(caster, target)
    @mp_required = 73
    @duration = 1
    @turns_remaining = duration
    @caster = caster
    @target = target
  end

  def effect
    caster.hp += 2
    target.hp -= 2
  end
end

class Shield < Spell

  def initialize(caster)
    @mp_required = 113
    @duration = 6
    @turns_remaining = duration
    @caster = caster
  end

  def effect
    caster.defense += 7
  end
end

class Poison < Spell

  def initialize(target)
    @mp_required = 173
    @duration = 6
    @turns_remaining = duration
    @target = target
  end

  def effect
    target.hp -= 3
  end
end

class Recharge < Spell

  def initialize(caster)
    @mp_required = 229
    @duration = 5
    @turns_remaining = duration
    @caster = caster
  end

  def effect
    caster.mp += 101
  end
end

class Wizard
  attr_accessor :name, :hp, :mp, :defense, :mana_expended

  def initialize
    @name = "Toth"
    @hp = 50
    @mp = 500
    @defense = 0
    @mana_expended = 0
  end

  def cast(spell)
    self.mp -= spell.mp_required
    self.mana_expended += spell.mp_required
    spell
  end

  def choose_spell(battle)
    if mp < 53
      self.hp = 0
    else
      while true
        spell_options = [MagicMissile.new(battle.foe),
                         Drain.new(battle.hero, battle.foe),
                         Shield.new(battle.hero),
                         Poison.new(battle.foe),
                         Recharge.new(battle.hero)]
        chosen_spell = spell_options.sample
        if enough_mp?(chosen_spell) && not_already_in_effect?(chosen_spell, battle.active_spells)
          cast(chosen_spell)
          return chosen_spell
        end
      end
    end
  end

  private

    def enough_mp?(spell)
      mp >= spell.mp_required
    end

    def not_already_in_effect?(spell, active_spells)
      active_spells.each do |active_spell|
        return false if spell.class == active_spell.class
      end
      true
    end
end

class Boss
  attr_accessor :name, :hp, :damage

  def initialize
    @name = "Nemesis"
    @hp = 58
    @damage = 9
  end

  def attack(target)
    result = self.damage - target.defense
    result = 1 if result < 1
    target.hp -= result
  end
end

class Battle
  attr_accessor :hero, :foe, :active_spells, :spells_cast

  def initialize(hero, foe, active_spells = [], spells_cast = [])
    @hero = hero
    @foe = foe
    @active_spells = active_spells
    # @spells_cast = spells_cast
  end

  def hero_turn
    hard_difficulty_penalty # for Part Two
    return if someone_dead?
    spell_effects
    return if someone_dead?
    the_spell = hero.choose_spell(self)
    active_spells << the_spell
    # spells_cast << the_spell
    clear_bonuses
  end

  def foe_turn
    spell_effects
    return if someone_dead?
    foe.attack(hero)
    clear_bonuses
  end

  def fight_to_the_death!
    while true
      break if someone_dead?
      hero_turn
      break if someone_dead?
      foe_turn
    end
    hero.hp > 0 ? hero : foe
  end

  private
    def spell_effects
      unless active_spells.empty?
        active_spells.each do |spell|
          spell.effect
          spell.turns_remaining -= 1
        end
        self.active_spells = active_spells.select { |spell| spell.turns_remaining > 0 }
      end
    end

    def clear_bonuses
      hero.defense = 0
    end

    def someone_dead?
      hero.hp <= 0 || foe.hp <= 0
    end

    def hard_difficulty_penalty
      hero.hp -= 1
    end
end

# Part One

def simulate_100000_battles
  winning_mana = []

  100_000.times do
    b = Battle.new(Wizard.new, Boss.new)
    winner = b.fight_to_the_death!
    if winner.is_a? Wizard               # best line in this code, thanks Ruby
      winning_mana << winner.mana_expended
    end
  end

  winning_mana.min
end

# (My input was Boss HP = 58, Boss damage = 9)

p simulate_100000_battles
# Part One answer: 1269 (uncomment line in Battle.hero_turn to run)
# Part Two answer: 1309 (might need to run a couple times--or up the number of iterations!)

# Part One sequence: Poison, Recharge, MagicMissile, Poison, Recharge, Shield, Poison, Drain, MagicMissile
# Part Two sequence: Poison, Recharge, Shield, Poison, Recharge, Shield, Poison, MagicMissile, MagicMissile

### Other Approaches ###
# My approach is non-exhaustive (taking the best result out of 100,000 random button-mashing
# simulations). It doesn't always work for Part Two (which could be fixed easily by upping the
# number of simulations). And with different inputs for the boss, it might need to be run a
# million or more times to find a viable solution. On the plus side, my code runs very fast
# compared to a more "correct," i.e. exhaustive approach. It's also object-oriented, though
# in desperate need of another round of refactoring.

# Exhaustive approach:
# 1) graph-based approach with each node as a spell cast and edge weight as MP cost--find
# the shortest path that results in the boss having 0 HP or less using a BFS or Dijkstra's
# Algorithm (priority queue, tree pruning, and/or memoization can also be added to speed it up).

# Full solution using an exhaustive approach from ZogStriP:
# https://github.com/ZogStriP/adventofcode-2015/blob/master/day22.rb

# MISSILE  = 0
# DRAIN    = 1
# SHIELD   = 2
# POISON   = 3
# RECHARGE = 4

# SPELL_COSTS  = [53, 73, 113, 173, 229]
# SPELL_TIMERS = [1, 1, 6, 6, 5]

# def deep_dup(object)
#   Marshal.load(Marshal.dump(object))
# end

# nodes = [
#   {
#     hero_hp: 50,
#     hero_mana: 500,
#     hero_armor: 0,
#     boss_hp: 58,
#     boss_damage: 9,
#     mana_spent: 0,
#     spell_timers: [0, 0, 0, 0, 0],
#     is_hero_turn: true,
#   }
# ]

# hard_mode = false
# lowest_mana_spent = Float::INFINITY

# until nodes.empty?
#   n = nodes.shift

#   # reset armor
#   n[:hero_armor] = 0

#   # hard mode
#   if hard_mode && n[:is_hero_turn]
#     n[:hero_hp] -= 1
#     next if n[:hero_hp] <= 0
#   end

#   # apply spell effects
#   0.upto(4) do |s|
#     if n[:spell_timers][s] > 0
#       n[:spell_timers][s] -= 1
#       case s
#       when MISSILE  then n[:boss_hp] -= 4
#       when DRAIN    then n[:boss_hp] -= 2; n[:hero_hp] += 2
#       when SHIELD   then n[:hero_armor] = 7
#       when POISON   then n[:boss_hp] -= 3
#       when RECHARGE then n[:hero_mana] += 101
#       end
#     end
#   end

#   # hero died
#   next if n[:hero_hp] <= 0

#   # boss died \o/
#   if n[:boss_hp] <= 0
#     lowest_mana_spent = n[:mana_spent] if n[:mana_spent] < lowest_mana_spent
#     next
#   end

#   if n[:is_hero_turn]
#     next if hard_mode && n[:hero_hp] <= 1
#     0.upto(4) do |s|
#       if n[:spell_timers][s] == 0 && n[:hero_mana] >= SPELL_COSTS[s] && n[:mana_spent] + SPELL_COSTS[s] < lowest_mana_spent
#         node = deep_dup(n)
#         node[:hero_mana] -= SPELL_COSTS[s]
#         node[:mana_spent] += SPELL_COSTS[s]
#         node[:spell_timers][s] = SPELL_TIMERS[s]
#         node[:is_hero_turn] = !node[:is_hero_turn]
#         nodes << node
#       end
#     end
#   else
#     node = deep_dup(n)
#     node[:hero_hp] -= [1, n[:boss_damage] - n[:hero_armor]].max
#     node[:is_hero_turn] = !node[:is_hero_turn]
#     nodes << node
#   end
# end

# p lowest_mana_spent
