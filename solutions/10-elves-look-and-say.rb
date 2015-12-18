# --- Day 10: Elves Look, Elves Say ---
# cf. https://www.youtube.com/watch?v=ea7lJkEhytA

# Today, the Elves are playing a game called look-and-say. They take turns making sequences by reading aloud the previous sequence and using that reading as the next sequence. For example, 211 is read as "one two, two ones", which becomes 1221 (1 2, 2 1s).

# Look-and-say sequences are generated iteratively, using the previous value as input for the next step. For each step, take the previous value, and replace each run of digits (like 111) with the number of digits (3) followed by the digit itself (1).

# For example:

# 1 becomes 11 (1 copy of digit 1).
# 11 becomes 21 (2 copies of digit 1).
# 21 becomes 1211 (one 2 followed by one 1).
# 1211 becomes 111221 (one 1, one 2, and two 1s).
# 111221 becomes 312211 (three 1s, two 2s, and one 1).
# Starting with the digits in your puzzle input, apply this process 40 times. What is the length of the result?


# --- Part Two ---

# Neat, right? You might also enjoy hearing John Conway talking about this sequence (that's Conway of Conway's Game of Life fame).

# Now, starting again with the digits in your puzzle input, apply this process 50 times. What is the length of the new result?

### My EXTREMELY SLOW SOLUTION -- storing the strings in memory is ridiculously costly! ###
def look_and_say_wrapper(input, iterations = 40)
	iterations.times do |x|
		input = look_and_say(input)
		p x
	end
	input.to_s.length
end

def look_and_say(input)
	old_str = input.to_s
	new_str = ""

	prev = ""
	count = 0
	i = 0

	while i < old_str.length
		if prev != "" && prev != old_str[i]
			new_str += count.to_s
			new_str += prev
			count = 1
		else
			count += 1
		end
		prev = old_str[i]
		i += 1
	end
	new_str += count.to_s
	new_str += prev
	new_str.to_i
end

# p look_and_say_wrapper(1321131112)
# Result: 329356

# p look_and_say_wrapper(1321131112, 50)
# [Never finished -- it took ~30 minutes to get to 44, then I scoped reddit for a better way]

### Someone else's very fast solution ###
input = '1321131112'
50.times do
	input = input.gsub(/(.)\1*/) { |s| s.size.to_s + s[0] }
	puts input.length
end
puts input.length