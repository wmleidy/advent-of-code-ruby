# Historical note of little to no interest to anyone but me:
# This problem marks the first time I competed for the leaderboard (i.e. had all
# previous problems solved, started the current problem at exactly at 11 pm CT
# and rushed to solve it, elegance of the code be damned). Throughout the course
# of the AOC challenges, I made a concerted effort to get on the leaderboard seven
# times, succeeding four of those times.

# Ended up at #65 with the recursive solution below, which I think is some of
# the highest quality code I've written for any of the AOC problems.

require 'json'

def convert
  file = File.read("../input/input12-objects.json")
  hash = JSON.parse(file)
end

def parse(data, count = 0)
  if data.is_a? Hash
    # unless data.has_value?("red") # Uncomment for Part Two
      data.each do |k, v|
        count = parse(v, count)
      end
    # end  # Uncomment for Part Two
  elsif data.is_a? Array
    data.each do |el|
      count = parse(el, count)
    end
  elsif data.is_a? Integer
    count += data
  end
  count
end 

p parse(convert)

### Other Approaches ###
# 1) Using Regex for Part One gets the answer super quick (but doesn't help
#    for Part Two)