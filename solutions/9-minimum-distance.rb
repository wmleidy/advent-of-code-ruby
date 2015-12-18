# --- Day 9: All in a Single Night ---

##### A Version of The Traveling Salesman Problem #####

# Every year, Santa manages to deliver all of his presents in a single night.

# This year, however, he has some new locations to visit; his elves have provided him the distances between every pair of locations. He can start and end at any two (different) locations he wants, but he must visit each location exactly once. What is the shortest distance he can travel to achieve this?

# For example, given the following distances:

# London to Dublin = 464
# London to Belfast = 518
# Dublin to Belfast = 141
# The possible routes are therefore:

# Dublin -> London -> Belfast = 982
# London -> Dublin -> Belfast = 605
# London -> Belfast -> Dublin = 659
# Dublin -> Belfast -> London = 659
# Belfast -> Dublin -> London = 605
# Belfast -> London -> Dublin = 982
# The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.

# What is the distance of the shortest route?

# --- Part Two ---

# The next year, just to show off, Santa decides to take the route with the longest distance instead.

# He can still start and end at any two (different) locations he wants, and he still must visit each location exactly once.

# For example, given the distances above, the longest route would be 982 via (for example) Dublin -> London -> Belfast.

# What is the distance of the longest route?

require_relative '../data-structures/graphs.rb'

def build_graph_io
	g = Graph.new
	places = []

	IO.foreach("help9-distances.txt") do |line|
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

	# construct minimal spanning tree (wrong approach here--it's actually the TSP)
	# g.prim
	g
end

def brute_force_tsp(graph)
	min_distance = 1.0/0.0
	# max_distance = 0 # for Part Two
	best_path = nil
	paths = (0..graph.count-1).to_a.permutation.to_a

	paths.each do |path|
		# p path
		cumulative_distance = 0
		path[0..path.length - 2].each_with_index do |start_index, i|
			end_index = path[i + 1]
			cumulative_distance += graph.vertices[start_index].weights[end_index]
		end
		if cumulative_distance < min_distance
			min_distance = cumulative_distance
			best_path = path
		end
		# For Part Two
		# if cumulative_distance > max_distance
		# 	max_distance = cumulative_distance
		# 	best_path = path
		# end
		# p cumulative_distance
	end
	[min_distance, best_path]
	# [max_distance, best_path]  # For Part Two
end

star_system = build_graph_io
p brute_force_tsp(star_system)

### Sweet way (but confusing) way to do it without using a graph class ###
# dist = {}
# $stdin.readlines.map(&:split).each do |x, to, y, equals, d|
#     dist[[x,y].sort] = d.to_i
# end

# p dist.keys.flatten.uniq.permutation.map { |comb|
#     comb.each_cons(2).reduce(0) {|s, x| s + dist[x.sort] }
# }.sort.rotate(-1).first(2)

### Another Ruby solution that's easier to read ###
# input = DATA.read.chomp.split("\n").map do |line|
#   line.match(/(\w+) to (\w+) = (\d+)/).captures
# end

# cities = input.flat_map {|trip| trip[0..1]}.uniq 

# distances = input.reduce({}) { |m, trip| m[trip[0..1].join] = trip[2].to_i; m }

# cities.permutation.map do |path|
#   path.each_cons(2).reduce(0) do |m,pair|
#     m += distances[pair.join('')] || distances[pair.rotate.join('')]
#   end
# end.min.tap {|x| p x}