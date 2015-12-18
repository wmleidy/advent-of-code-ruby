# --- Day 6: Probably a Fire Hazard ---

# Because your neighbors keep defeating you in the holiday house decorating contest year after year, you've decided to deploy one million lights in a 1000x1000 grid.

# Furthermore, because you've been especially nice this year, Santa has mailed you instructions on how to display the ideal lighting configuration.

# Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions include whether to turn on, turn off, or toggle various inclusive ranges given as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights all start turned off.

# To defeat your neighbors this year, all you have to do is set up your lights by doing the instructions Santa sent you in order.

# For example:

# turn on 0,0 through 999,999 would turn on (or leave on) every light.
# toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, and turning on the ones that were off.
# turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
# After following the instructions, how many lights are lit?

# --- Part Two ---

# You just finish implementing your winning light pattern when you realize you mistranslated Santa's message from Ancient Nordic Elvish.

# The light grid you bought actually has individual brightness controls; each light can have a brightness of zero or more. The lights all start at zero.

# The phrase turn on actually means that you should increase the brightness of those lights by 1.

# The phrase turn off actually means that you should decrease the brightness of those lights by 1, to a minimum of zero.

# The phrase toggle actually means that you should increase the brightness of those lights by 2.

# What is the total brightness of all lights combined after following Santa's instructions?

# For example:

# turn on 0,0 through 0,0 would increase the total brightness by 1.
# toggle 0,0 through 999,999 would increase the total brightness by 2000000.


def create_grid
	# Array.new(1000) { Array.new(1000, false) }  # Part One
	Array.new(1000) { Array.new(1000, 0) }
end

def count_lights_on(matrix)
	count = 0
	matrix.each do |row|
		row.each do |cell|
			# count += 1 if cell  # Part One
			count += cell
		end
	end
	count
end

def process_instructions
	grid = create_grid

	IO.foreach("help6-light-instructions.txt") do |line|
		instr = line.split
		if instr[1] == "on"
			# grid = turn_one_way(grid, instr[2], instr[4], true)  # Part One
			grid = turn_one_way(grid, instr[2], instr[4], 1)
		elsif instr[1] == "off"
			# grid = turn_one_way(grid, instr[2], instr[4], false)  # Part One
			grid = turn_one_way(grid, instr[2], instr[4], -1)
		elsif instr[0] == "toggle"
			grid = toggle(grid, instr[1], instr[3])
		end
	end
	count_lights_on(grid)
end

def turn_one_way(matrix, start_values, end_values, value)
	start_x = start_values.split(",")[0].to_i
	start_y = start_values.split(",")[1].to_i
	end_x   = end_values.split(",")[0].to_i
	end_y   = end_values.split(",")[1].to_i

	i = start_x
	while i <= end_x
		j = start_y
		while j <= end_y
			# matrix[i][j] = boolean  # Part One
			matrix [i][j] += value
			matrix [i][j] = 0 if matrix[i][j] < 0
			j += 1
		end
		i += 1
	end
	matrix
end

def toggle(matrix, start_values, end_values)
	start_x = start_values.split(",")[0].to_i
	start_y = start_values.split(",")[1].to_i
	end_x   = end_values.split(",")[0].to_i
	end_y   = end_values.split(",")[1].to_i

	i = start_x
	while i <= end_x
		j = start_y
		while j <= end_y
			# matrix[i][j] ? matrix[i][j] = false : matrix[i][j] = true  # Part One
			matrix[i][j] += 2
			j += 1
		end
		i += 1
	end
	matrix
end

p process_instructions


### Reddit answer for Part Two ### 

# require 'matrix'

# controls = { 'turn on' => 1, 'turn off' => -1, 'toggle' => 2 }

# grid = Matrix.zero(1000)
# IO.readlines('input.txt').each { |str|
#   str =~ /\A(.*)\s(\d+),(\d+)\sthrough\s(\d+),(\d+)/
#   ($2..$4).each { |x|
#     ($3..$5).each { |y|
#       grid.send(:[]=, x.to_i, y.to_i, [0, grid[x.to_i, y.to_i] + controls[$1]].max)
#     }
#   }
# }

# puts grid.reduce(:+)