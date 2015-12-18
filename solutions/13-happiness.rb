# --- Day 13: Knights of the Dinner Table ---

# In years past, the holiday feast with your family hasn't gone so well. Not everyone gets along! This year, you resolve, will be different. You're going to find the optimal seating arrangement and avoid all those awkward conversations.

# You start by writing up a list of everyone invited and the amount their happiness would increase or decrease if they were to find themselves sitting next to each other person. You have a circular table that will be just big enough to fit everyone comfortably, and so each person will have exactly two neighbors.

# For example, suppose you have only four attendees planned, and you calculate their potential happiness as follows:

# Alice would gain 54 happiness units by sitting next to Bob.
# Alice would lose 79 happiness units by sitting next to Carol.
# Alice would lose 2 happiness units by sitting next to David.
# Bob would gain 83 happiness units by sitting next to Alice.
# Bob would lose 7 happiness units by sitting next to Carol.
# Bob would lose 63 happiness units by sitting next to David.
# Carol would lose 62 happiness units by sitting next to Alice.
# Carol would gain 60 happiness units by sitting next to Bob.
# Carol would gain 55 happiness units by sitting next to David.
# David would gain 46 happiness units by sitting next to Alice.
# David would lose 7 happiness units by sitting next to Bob.
# David would gain 41 happiness units by sitting next to Carol.
# Then, if you seat Alice next to David, Alice would lose 2 happiness units (because David talks so much), but David would gain 46 happiness units (because Alice is such a good listener), for a total change of 44.

# If you continue around the table, you could then seat Bob next to Alice (Bob gains 83, Alice gains 54). Finally, seat Carol, who sits next to Bob (Carol gains 60, Bob loses 7) and David (Carol gains 55, David gains 41). The arrangement looks like this:

#      +41 +46
# +55   David    -2
# Carol       Alice
# +60    Bob    +54
#      -7  +83
# After trying every other seating arrangement in this hypothetical scenario, you find that this one is the most optimal, with a total change in happiness of 330.

# What is the total change in happiness for the optimal seating arrangement of the actual guest list?

# --- Part Two ---

# In all the commotion, you realize that you forgot to seat yourself. At this point, you're pretty apathetic toward the whole thing, and your happiness wouldn't really go up or down regardless of who you sit next to. You assume everyone else would be just as ambivalent about sitting next to you, too.

# So, add yourself to the list, and give all happiness relationships that involve you a score of 0.

# What is the total change in happiness for the optimal seating arrangement that actually includes yourself?



# Missed the leaderboard by a minute! (Lots of mistakes due to hurrying plus I lost a minute when I misread Part Two submission instructions...)

require_relative '../data-structures/graphs.rb'

def build_graph_io
  g = Graph.new
  people = []

  IO.foreach("help13-happiness.txt") do |line|
    data = line.split
    
    # if people don't yet exist in graph, add it to graph and tracker array
    unless people.index(data[0])
      people << data[0]
      g.add_vertex(data[0])
    end
  end

  IO.foreach("help13-happiness.txt") do |line|
    data = line.split
    target = data.last[0..-2]

    if data[2] == "lose"
      happiness = data[3].to_i * -1
    else
      happiness = data[3].to_i
    end
    # now add directed edge to graph
    g.add_edge(data[0], target, happiness, false)
  end

  # For Part Two
  # g.add_vertex("Bill")
  # g.vertices.each do |v|
  #   # all edges are undirected and 0
  #   g.add_edge(v.name, "Bill", 0)
  # end

  g
end

def brute_force_happiness(graph)
  arrangements = (0..graph.count-1).to_a.permutation.to_a
  max_happiness = -1.0/0.0
  best_arrangement = nil

  arrangements.each do |arrangement|
    total_happiness = 0
    arrangement.each_with_index do |person, i|
      if i == 0
        total_happiness += graph.vertices[person].weights[arrangement[i+1]]
        total_happiness += graph.vertices[person].weights[arrangement[graph.count - 1]]
      elsif i == graph.count - 1
        total_happiness += graph.vertices[person].weights[arrangement[i-1]]
        total_happiness += graph.vertices[person].weights[arrangement[0]]
      else
        total_happiness += graph.vertices[person].weights[arrangement[i+1]]
        total_happiness += graph.vertices[person].weights[arrangement[i-1]]
      end
    end
    if total_happiness > max_happiness
      max_happiness = total_happiness
      best_arrangement = arrangement
    end
  end
  p [max_happiness, best_arrangement]
end

happiness_graph = build_graph_io
brute_force_happiness(happiness_graph)

### Nice and compact from Reddit ###

# h = {}
# r = /(\w+).+(\w) (\d+).+?(\w+)\./

# ARGF.read.scan(r).each do |a, mood, units, b|
#   (h[a] ||= {})[b] = units.to_i * (mood <=> ?i)
# end

# p h.keys.permutation.map { |p|
#   (p << p[0]).each_cons(2).map { |a, b|
#     h[a][b] + h[b][a]
#   }.reduce(:+)
# }.max