# Historical note of little to no interest to anyone but me:
# made leaderboard despite the rather verbose class implementation used

class Reindeer
  attr_accessor :name, :velocity, :spurt_time, :rest_time, :winning_seconds

  def initialize(name, velocity, spurt_time, rest_time)
    @name = name
    @velocity = velocity
    @spurt_time = spurt_time
    @rest_time = rest_time
    @winning_seconds = 0  # For Part Two
  end

  def find_distance(total_seconds)
    distance = 0
    until total_seconds <= 0
      can_go = spurt_time
      while can_go > 0
        distance += velocity
        can_go -= 1
        total_seconds -= 1
        break if total_seconds == 0
      end
      total_seconds -= rest_time
    end
    distance
  end
end

def reindeer_io
  reindeer = []

  IO.foreach("../input/input14-reindeer.txt") do |line|
    data = line.split
    
    r = Reindeer.new(data[0], data[3].to_i, data[6].to_i, data[13].to_i)
    reindeer << r
  end

  reindeer
end

# Part One
def find_winner(arr, seconds)
  arr.each do |reindeer|
    p [reindeer.name, reindeer.find_distance(seconds)]
  end
end

# Part Two
def find_leaders(arr, seconds)

  (1..seconds).to_a.each do |second_count|
    # Note: #max_by is not 100% accurate here as it doesn't account for ties
    leader = arr.max_by { |reindeer| reindeer.find_distance(second_count) }
    leader.winning_seconds += 1
  end

  arr.each do |reindeer|
    p [reindeer.name, reindeer.winning_seconds]
  end
end

puts "Part One (distance achieved)"
find_winner(reindeer_io, 2503)
puts ""
puts "Part Two (leading seconds)"
find_leaders(reindeer_io, 2503)

### Other approaches ###
# 1) Complete solution to Part One using #cycle:
  # def parse line
  #   split_line = line.split " "
  #   speed = split_line[3].to_i
  #   sprint_time = split_line[6].to_i
  #   rest_time = split_line[-2].to_i

  #   progress = Array.new(sprint_time, speed) + Array.new(rest_time, 0)
  #   progress.cycle.first(2503).inject(:+)
  # end

  # puts DATA.map{ |line| parse(line) }.max