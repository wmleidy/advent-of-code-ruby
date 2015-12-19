def count_string_lengths_io
	count = 0
	IO.foreach("../input/input8-strings.txt") do |line|
		core_string = line[1..-3]
		evaluated_string = eval "\"#{core_string}\""
		count += core_string.length - evaluated_string.length
		count += 2 # for beginning and ending quotes
	end
	count
end

def count_string_lengths_io2
	count = 0
	IO.foreach("../input/input8-strings.txt") do |line|
		count += 2 # for beginning and ending quotes
		count += escaped_characters(line.chomp)
	end
	count
end

def escaped_characters(str)
	tally = 0
	str.chars.each do |char|
		if char == '\\' || char == '"'
			tally += 1
		end
	end
	tally
end

p count_string_lengths_io
p count_string_lengths_io2

### Other Approach (Much Cleaner) ###

# # Part One
# code_chars = 0
# real_chars = 0

# File.readlines("8-1.data").each do |line|
#   line = line.chomp
#   code_chars += line.length
#   real_chars += eval(line).length
# end

# puts code_chars - real_chars

# # Part Two
# code_chars = 0
# esc_chars = 0

# File.readlines("8-1.data").each do |line|
#   line = line.chomp
#   code_chars += line.length
#   esc_chars += line.dump.length
# end

# puts esc_chars - code_chars