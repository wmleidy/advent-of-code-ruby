# --- Day 18: Like a GIF For Your Yard ---

# After the million lights incident, the fire code has gotten stricter: now, at most ten thousand lights are allowed. You arrange them in a 100x100 grid.

# Never one to let you down, Santa again mails you instructions on the ideal lighting configuration. With so few lights, he says, you'll have to resort to animation.

# Start by setting your lights to the included initial configuration (your puzzle input). A # means "on", and a . means "off".

# Then, animate your grid in steps, where each step decides the next configuration based on the current one. Each light's next state (either on or off) depends on its current state and the current states of the eight lights adjacent to it (including diagonals). Lights on the edge of the grid might have fewer than eight neighbors; the missing ones always count as "off".

# For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered 1 through 8, and the light marked B, which is on an edge, only has the neighbors marked 1 through 5:

# 1B5...
# 234...
# ......
# ..123.
# ..8A4.
# ..765.
# The state a light should have next is based on its current state (on or off) plus the number of neighbors that are on:

# A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
# A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
# All of the lights update simultaneously; they all consider the same current state before moving to the next.

# Here's a few steps from an example configuration of another 6x6 grid:

# Initial state:
# .#.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####..

# After 1 step:
# ..##..
# ..##.#
# ...##.
# ......
# #.....
# #.##..

# After 2 steps:
# ..###.
# ......
# ..###.
# ......
# .#....
# .#....

# After 3 steps:
# ...#..
# ......
# ...#..
# ..##..
# ......
# ......

# After 4 steps:
# ......
# ......
# ..##..
# ..##..
# ......
# ......
# After 4 steps, this example has four lights on.

# In your grid of 100x100 lights, given your initial configuration, how many lights are on after 100 steps?

# --- Part Two ---

# You flip the instructions over; Santa goes on to point out that this is all just an implementation of Conway's Game of Life. At least, it was, until you notice that something's wrong with the grid of lights you bought: four lights, one in each corner, are stuck on and can't be turned off. The example above will actually run like this:

# Initial state:
# ##.#.#
# ...##.
# #....#
# ..#...
# #.#..#
# ####.#

# After 1 step:
# #.##.#
# ####.#
# ...##.
# ......
# #...#.
# #.####

# After 2 steps:
# #..#.#
# #....#
# .#.##.
# ...##.
# .#..##
# ##.###

# After 3 steps:
# #...##
# ####.#
# ..##.#
# ......
# ##....
# ####.#

# After 4 steps:
# #.####
# #....#
# ...#..
# .##...
# #.....
# #.#..#

# After 5 steps:
# ##.###
# .##..#
# .##...
# .##...
# #.#...
# ##...#
# After 5 steps, this example now has 17 lights on.

# In your grid of 100x100 lights, given your initial configuration, but with the four corners always in the on state, how many lights are on after 100 steps?


def create_grid
  Array.new(100) { Array.new(100, 0) }
end

def lights_io
  grid = create_grid
  y = 0

  IO.foreach("help18-animated-lights.txt") do |line|
    lights = line.chomp.chars
    lights.each_with_index do |setting, x|
      grid[x][y] = 1 if setting == "#"
    end
    y += 1
  end
  grid
end

def shift_lights(matrix)
  new_state = create_grid
  matrix.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      neighbors_on = 0
      neighbors_on += 1 unless x == 0  || y == 0  || matrix[x - 1][y - 1] == 0
      neighbors_on += 1 unless x == 0             || matrix[x - 1][y]     == 0
      neighbors_on += 1 unless x == 0  || y == 99 || matrix[x - 1][y + 1] == 0
      neighbors_on += 1 unless            y == 0  || matrix[x][y - 1]     == 0
      neighbors_on += 1 unless            y == 99 || matrix[x][y + 1]     == 0
      neighbors_on += 1 unless x == 99 || y == 0  || matrix[x + 1][y - 1] == 0
      neighbors_on += 1 unless x == 99            || matrix[x + 1][y]     == 0
      neighbors_on += 1 unless x == 99 || y == 99 || matrix[x + 1][y + 1] == 0
      if cell == 1
        new_state[x][y] = 1 if neighbors_on == 2 || neighbors_on == 3
      else
        new_state[x][y] = 1 if neighbors_on == 3
      end
    end
  end
  new_state[0][0] = new_state[0][99] = new_state[99][0] = new_state[99][99] = 1 # For Part Two
  new_state
end

def do_100_times(matrix)
  100.times do
    matrix = shift_lights(matrix)
  end
  total_lights_on(matrix)
end

def total_lights_on(matrix)
  sum = 0
  matrix.each do |row|
    row.each do |cell|
      sum += 1 if cell == 1
    end
  end
  sum
end

p do_100_times(lights_io)