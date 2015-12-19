# Once again choosing to leverage the pointer-based graph class
# I built while studying data structures...its flexibility to
# construct directed graphs just by changing a flag is handy here...
require_relative '../data-structures/graphs.rb'

def build_graph_io
  g = Graph.new
  people = []

  # Generate people (vertices)
  IO.foreach("../input/input13-happiness.txt") do |line|
    data = line.split
    
    unless people.index(data[0])
      people << data[0]
      g.add_vertex(data[0])
    end
  end

  # Generate happiness scores (edges)
  IO.foreach("../input/input13-happiness.txt") do |line|
    data = line.split
    originator = data[0]
    target = data.last[0..-2]

    if data[2] == "lose"
      happiness = data[3].to_i * -1
    else
      happiness = data[3].to_i
    end
    # now add directed edge to graph (using "false" flag)
    g.add_edge(originator, target, happiness, false)
  end

  # Uncomment for Part Two (note that all edges are undirected and equal to 0)
  # g.add_vertex("wmleidy")
  # g.vertices.each do |v|
  #   g.add_edge(v.name, "wmleidy", 0)
  # end

  g
end

# As with Day #9, reopen Graph class and tweak TSP algorithm for "return trips"
class Graph

  def brute_force_happiness(return_to_origin = true)
    max_happiness = -1.0/0.0
    best_path = nil
    paths = (0...count).to_a.permutation.to_a

    paths.each do |path|
      cumulative_happiness = 0
      path.each_with_index do |person_index, i|
        # if and elsif handle the "wrap-around cases"
        if i == 0 
          cumulative_happiness += vertices[person_index].weights[path[i+1]]
          cumulative_happiness += vertices[person_index].weights[path[count-1]]
        elsif i == count - 1
          cumulative_happiness += vertices[person_index].weights[path[i-1]]
          cumulative_happiness += vertices[person_index].weights[path[0]]
        else
          cumulative_happiness += vertices[person_index].weights[path[i+1]]
          cumulative_happiness += vertices[person_index].weights[path[i-1]]
        end
      end

      if cumulative_happiness > max_happiness
        max_happiness = cumulative_happiness
        best_path = path
      end
    end

    puts "Maximum happiness is #{max_happiness}"
    puts "Best arrangement: #{humanize_tsp_route(best_path, return_to_origin)}"
  end

end

happiness_graph = build_graph_io
happiness_graph.brute_force_happiness

### Other Approaches ###

# 1) A (very) concise and impressive solution for Part One with nice Regex usage
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