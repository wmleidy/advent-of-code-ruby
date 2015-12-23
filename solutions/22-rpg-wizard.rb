# Most difficult one yet...and also the most fun to write!
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
  attr_accessor :hero, :foe, :active_spells

  def initialize(hero, foe, active_spells = [])
    @hero = hero
    @foe = foe
    @active_spells = active_spells
  end

  def hero_turn
    hard_difficulty_penalty # for Part Two
    return if someone_dead?
    spell_effects
    return if someone_dead?
    active_spells << hero.choose_spell(self)
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

p simulate_100000_battles
# Part One answer: 1269 (uncomment line in Battle.hero_turn to run)
# Part Two answer: 1309
