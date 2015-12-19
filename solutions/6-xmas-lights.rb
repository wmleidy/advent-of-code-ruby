def create_grid
  # Array.new(1000) { Array.new(1000, false) } # Part One
  Array.new(1000) { Array.new(1000, 0) }     # Part Two
end

def count_lights(matrix)
  matrix.inject(0) do |matrix_total, row|
    matrix_total += row.inject(0) do |row_total, cell|
      # cell ? row_total += 1 : row_total # Part One
      row_total += cell                 # Part Two
    end
  end
end

def process_instructions
  grid = create_grid

  IO.foreach("../input/input6-light-instructions.txt") do |line|
    instr = line.gsub(/turn\s/, "").gsub(/through\s/, "").split
    method = instr[0]
    start_values = instr[1]
    end_values = instr[2]
    start_x = start_values.split(",")[0].to_i
    start_y = start_values.split(",")[1].to_i
    end_x   = end_values.split(",")[0].to_i
    end_y   = end_values.split(",")[1].to_i

    if method == "on"
      # grid = turn_one_way(grid, start_x, end_x, start_y, end_y, true) # Part One
      grid = turn_one_way(grid, start_x, end_x, start_y, end_y, 1)    # Part Two
    elsif method == "off"
      # grid = turn_one_way(grid, start_x, end_x, start_y, end_y, false) # Part One
      grid = turn_one_way(grid, start_x, end_x, start_y, end_y, -1)    # Part Two
    elsif method == "toggle"
      grid = toggle(grid, start_x, end_x, start_y, end_y)
    end
  end
  count_lights(grid)
end

def turn_one_way(matrix, start_x, end_x, start_y, end_y, value)
  for i in (start_x..end_x)
    for j in (start_y..end_y)
      # matrix[i][j] = value                  # Part One
      matrix [i][j] += value                # Part Two
      matrix [i][j] = 0 if matrix[i][j] < 0 # Part Two
    end
  end
  matrix
end

def toggle(matrix, start_x, end_x, start_y, end_y)
  for i in (start_x..end_x)
    for j in (start_y..end_y)
      # matrix[i][j] ? matrix[i][j] = false : matrix[i][j] = true # Part One
      matrix[i][j] += 2                                         # Part Two
    end
  end
  matrix
end

p process_instructions
# To run for other Part, comment/uncomment lines above