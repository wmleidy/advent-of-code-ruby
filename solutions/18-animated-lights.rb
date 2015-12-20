# Builds on Day #6
def create_grid
  Array.new(100) { Array.new(100, 0) }
end

def lights_io
  grid = create_grid
  y = 0

  IO.foreach("../input/input18-animated-lights.txt") do |line|
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
      # not the DRYest way to deal with edges, but...
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

# Comment/uncomment line 41 for Part One/Two results
p do_100_times(lights_io)

### Other Approaches ###
# 1) By leaving a permanently empty ring of cells around the main grid, there are fewer checks
#    to perform (although the above code is still very quick, runs in under in a second)