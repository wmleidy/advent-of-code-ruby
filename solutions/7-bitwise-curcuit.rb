# --- Day 7: Some Assembly Required ---

# This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates! Unfortunately, little Bobby is a little under the recommended age range, and he needs help assembling the circuit.

# Each wire has an identifier (some lowercase letters) and can carry a 16-bit signal (a number from 0 to 65535). A signal is provided to each wire by a gate, another wire, or some specific value. Each wire can only get a signal from one source, but can provide its signal to multiple destinations. A gate provides no signal until all of its inputs have a signal.

# The included instructions booklet describes how to connect the parts together: x AND y -> z means to connect wires x and y to an AND gate, and then connect its output to wire z.

# For example:

# 123 -> x means that the signal 123 is provided to wire x.
# x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
# p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
# NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.
# Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to emulate the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide operators for these gates.

# For example, here is a simple circuit:

# 123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i
# After it is run, these are the signals on the wires:

# d: 72
# e: 507
# f: 492
# g: 114
# h: 65412
# i: 65079
# x: 123
# y: 456
# In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?

# --- Part Two ---

# Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire a). What new signal is ultimately provided to wire a?

# For Part One, line #55 of 'help7-circuit.txt' read "19138 -> b"
# For Part Two, this needs to be changed to read "16076 -> b"


class String
  def is_integer?
    self.to_i.to_s == self
  end
end

def get_instructions
	instructions_arr = []

	IO.foreach("help7-circuit.txt") do |line|
		instructions_arr << line.chomp
	end

	instructions_arr
end

# in retrospect, probably would have been easier to sort just based on the last value in the string (!)
def sort_instructions(arr)
	arr.sort_by do |instruction|
		variable_names = instruction.split.reject { |thing| thing == "->" || thing == "AND" || thing == "OR" || thing == "NOT" || thing == "LSHIFT" || thing == "RSHIFT" || thing.is_integer? }
		max = variable_names.max
		if max.length == 1 && !variable_names.select { |var| var.length == 2 }.empty?
			max = variable_names.reject { |var| var.length == 1}.max
		end
		[max.length, max]
	end
end

# Confirm that our instructions get ordered correctly...
# puts sort_instructions(get_instructions)

def run_instructions(arr)
	arr.each do |instr|
		data = instr.split
		var = data.last
		instance_variable_set("@#{var}", parser(data[0..-3]))
		puts "#{var}:" + instance_variable_get("@#{var}").to_s
	end
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
	else
		case arr[1]
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

### brilliant Ruby solution ###
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

### class-based Ruby solution ###
# class Circuit
#   TRANSFORMS = {
#     "LSHIFT"         => "<<",
#     "RSHIFT"         => ">>",
#     "NOT"            => "~",
#     "AND"            => "&",
#     "OR"             => "|",
#     /\b(if|do|in)\b/ => "\\1_",
#   }

#   def add(line)
#     TRANSFORMS.each do |from, to|
#       line.gsub!(from, to)
#     end

#     expr, name = line.strip.split(" -> ")

#     method = "def #{name}; @#{name} ||= #{expr}; end"

#     puts method
#     instance_eval method
#   end
# end

# circuit = Circuit.new
# open("input.txt").each_line { |line| circuit.add(line) }
# # circuit.add("46065 -> b")
# p circuit.a

### a third Ruby solution ###

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
