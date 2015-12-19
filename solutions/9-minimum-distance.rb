# Use pointer-based graph class I built while studying data structures
require_relative '../data-structures/graphs.rb'

def build_graph_io
  g = Graph.new
  places = []

  IO.foreach("../input/input9-distances.txt") do |line|
    data = line.split
    
    # if locations don't yet exist in graph, add it to graph and tracker array
    unless places.index(data[0])
      places << data[0]
      g.add_vertex(data[0])
    end

    unless places.index(data[2])
      places << data[2]
      g.add_vertex(data[2])
    end

    # now add edge to graph
    g.add_edge(data[0], data[2], data[4].to_i)
  end
  g
end

star_system = build_graph_io
star_system.brute_force_tsp(false)

# Part Two

# Reopen Graph class and tweak TSP algorithm
# (basically replace min_distance with max_distance)
# Note: only works for fully connected graphs (as in this problem)
class Graph

  def brute_force_tsp_longest_valid_route(return_to_origin = true)
    max_distance = 0
    best_path = nil
    paths = (0...count).to_a.permutation.to_a

    paths.each do |path|
      cumulative_distance = 0
      path[0..path.length - 2].each_with_index do |start_index, i|
        end_index = path[i + 1]
        cumulative_distance += vertices[start_index].weights[end_index]
      end

      if return_to_origin
        cumulative_distance += vertices[path[-1]].weights[path[0]]
      end

      if cumulative_distance > max_distance
        max_distance = cumulative_distance
        best_path = path
      end
    end

    if return_to_origin
      puts "The longest distance for a complete loop is #{max_distance}"
    else
      puts "The longest route to visit each vertex exactly once is #{max_distance}"
    end
    puts humanize_tsp_route(best_path, return_to_origin)
    [max_distance, best_path]
  end

end

star_system.brute_force_tsp_longest_valid_route(false)