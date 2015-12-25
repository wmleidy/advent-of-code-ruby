# Instructions:
# To continue, please consult the code grid in the manual.  Enter the code at row 3010, column 3019.

def generate_code(num)
  num * 252533 % 33554393
end

def iterator
  grid = Array.new(6050) { Array.new(6050) }
  grid[1][1] = input = 20151125
  sum = 3
  while sum < 6050
    column = sum - 1
    row = 1
    while row < sum
      input = generate_code(input)
      grid[column][row] = input
      column -= 1
      row += 1
    end
    sum += 1
  end
  grid[3010][3019]
end

p iterator

### Other Approaches ###
# 1) Use more math, for example:
  # row = 2947
  # column = 3029
  # n = row + column - 2
  # iterations = (n * (n + 1)) / 2 + column - 1
  # result = 20151125
  # iterations.times do
  #   result = (result * 252533) % 33554393
  # end

# puts "Value at (#{row}, #{column}): #{result}"