# For Part One, line #55 of 'input7-circuit.txt' reads "19138 -> b"
# For Part Two, this needs to be changed to read "16076 -> b"

class String
  def is_integer?
    self.to_i.to_s == self
  end
end

def get_instructions
  instructions_arr = []
  IO.foreach("../input/input7-circuit.txt") do |line|
    instructions_arr << line.chomp
  end
  instructions_arr
end

def sort_instructions(arr)
  sorted = arr.sort_by do |instruction|
    variable_to_set = instruction.split.last
    [variable_to_set.length, variable_to_set]
  end
  # maneuver "a" to end of list
  sorted.push(sorted.shift)
end

# Confirm that our instructions get ordered correctly...
# puts sort_instructions(get_instructions)

def run_instructions(arr)
  arr.each do |instr|
    data = instr.split
    var = data.last
    instance_variable_set("@#{var}", parser(data[0..-3]))
    # puts "#{var}:" + instance_variable_get("@#{var}").to_s
  end
  # the answer...
  @a
end


def parser(arr)
  # cases of setting equal to a number or variable
  if arr.length == 1
    if arr[0].is_integer?
      arr[0].to_i
    else
      instance_variable_get("@#{arr[0]}")
    end
  # cases involving NOT
  elsif arr.length == 2
    65535 - instance_variable_get("@#{arr[1]}")
  # all other operations
  else
    operator = arr[1]
    case operator
    when "AND"
      first  = arr[0].is_integer? ? arr[0].to_i : instance_variable_get("@#{arr[0]}")
      second = arr[2].is_integer? ? arr[2].to_i : instance_variable_get("@#{arr[2]}")
      first & second
    when "OR"
      first  = arr[0].is_integer? ? arr[0].to_i : instance_variable_get("@#{arr[0]}")
      second = arr[2].is_integer? ? arr[2].to_i : instance_variable_get("@#{arr[2]}")
      first | second
    when "LSHIFT"
      instance_variable_get("@#{arr[0]}") << arr[2].to_i
    when "RSHIFT"
      instance_variable_get("@#{arr[0]}") >> arr[2].to_i
    end
  end
end

p run_instructions(sort_instructions(get_instructions))

### Other, neater and cleaner approaches (from Reddit) ###

### 1 ### 
# input = DATA.read.chomp.split("\n")
# substitutions = {'AND' => '&', 'OR' => '|', 'NOT' => '~', 
#                  'RSHIFT' => '>>', 'LSHIFT' => '<<'}

# equations = input.map do |line|
#   line.gsub!(/([a-z]+)/, "@\\1_")
#   rhs, lhs = line.match(/(.*) -> (.*)/).captures
#   substitutions.each {|k,v| rhs.sub!(k,v)}
#   "#{lhs} = #{rhs}"
# end

# go = true
# while go do
#   go = false
#   equations.each { |code| eval code rescue go = true }
# end

# p @a_

### 2 ###
# trans = {
#   'AND'    => '&',
#   'OR'     => '|',
#   'NOT'    => '~',
#   'LSHIFT' => '<<',
#   'RSHIFT' => '>>'
# }

# p eval ARGF.
#   read.
#   gsub(Regexp.union(trans.keys), trans).
#   gsub(/(.+?) -> (\w+)/) { "%2s = #$1" % $2 }.
#   upcase.
#   split("\n").
#   sort.
#   rotate.
#   join(?;)