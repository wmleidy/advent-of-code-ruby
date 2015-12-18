# --- Day 14: Reindeer Olympics ---

# This year is the Reindeer Olympics! Reindeer can fly at high speeds, but must rest occasionally to recover their energy. Santa would like to know which of his reindeer is fastest, and so he has them race.

# Reindeer can only either be flying (always at their top speed) or resting (not moving at all), and always spend whole seconds in either state.

# For example, suppose you have the following Reindeer:

# Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
# Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
# After one second, Comet has gone 14 km, while Dancer has gone 16 km. After ten seconds, Comet has gone 140 km, while Dancer has gone 160 km. On the eleventh second, Comet begins resting (staying at 140 km), and Dancer continues on for a total distance of 176 km. On the 12th second, both reindeer are resting. They continue to rest until the 138th second, when Comet flies for another ten seconds. On the 174th second, Dancer flies for another 11 seconds.

# In this example, after the 1000th second, both reindeer are resting, and Comet is in the lead at 1120 km (poor Dancer has only gotten 1056 km by that point). So, in this situation, Comet would win (if the race ended at 1000 seconds).

# Given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, what distance has the winning reindeer traveled?

# --- Part Two ---

# Seeing how reindeer move in bursts, Santa decides he's not pleased with the old scoring system.

# Instead, at the end of each second, he awards one point to the reindeer currently in the lead. (If there are multiple reindeer tied for the lead, they each get one point.) He keeps the traditional 2503 second time limit, of course, as doing otherwise would be entirely ridiculous.

# Given the example reindeer from above, after the first second, Dancer is in the lead and gets one point. He stays in the lead until several seconds into Comet's second burst: after the 140th second, Comet pulls into the lead and gets his first point. Of course, since Dancer had been in the lead for the 139 seconds before that, he has accumulated 139 points by the 140th second.

# After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only has 312. So, with the new scoring system, Dancer would win (if the race ended at 1000 seconds).

# Again given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, how many points does the winning reindeer have?



# Placed #62 on the leaderboard with a time of 21 minutes, 19 seconds!

class Reindeer
  attr_accessor :name, :pace, :go_time, :rest_time, :winning_seconds

  def initialize(name, pace, go_time, rest_time)
    @name = name
    @pace = pace
    @go_time = go_time
    @rest_time = rest_time
    @winning_seconds = 0  # For Part Two
  end

  def find_distance(total_seconds)
    d = 0
    until total_seconds <= 0
      can_go = go_time
      while can_go > 0
        d += pace
        can_go -= 1
        total_seconds -= 1
        break if total_seconds == 0
      end
      total_seconds -= rest_time
    end
    d
  end
end

def reindeer_io
  reindeer = []

  IO.foreach("help14-reindeer.txt") do |line|
    data = line.split
    
    r = Reindeer.new(data[0], data[3].to_i, data[6].to_i, data[13].to_i)
    p r
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
    leader = arr.max_by { |reindeer| reindeer.find_distance(second_count) }
    leader.winning_seconds += 1
  end

  arr.each do |reindeer|
    p [reindeer.name, reindeer.winning_seconds]
  end
end

find_winner(reindeer_io, 2503)
puts ""
find_leaders(reindeer_io, 2503)

### concise Reddit solution ###
# def parse line
#   split_line = line.split " "
#   speed = split_line[3].to_i
#   sprint_time = split_line[6].to_i
#   rest_time = split_line[-2].to_i

#   progress = Array.new(sprint_time, speed) + Array.new(rest_time, 0)
#   progress.cycle.first(2503).inject(:+)
# end

puts DATA.map{ |line| parse(line) }.max