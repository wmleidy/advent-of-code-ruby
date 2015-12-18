# --- Day 12: JSAbacusFramework.io ---

# Santa's Accounting-Elves need help balancing the books after a recent order. Unfortunately, their accounting software uses a peculiar storage format. That's where you come in.

# They have a JSON document which contains a variety of things: arrays ([1,2,3]), objects ({"a":1, "b":2}), numbers, and strings. Your first job is to simply find all of the numbers throughout the document and add them together.

# For example:

# [1,2,3] and {"a":2,"b":4} both have a sum of 6.
# [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
# {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
# [] and {} both have a sum of 0.
# You will not encounter any strings containing numbers.

# What is the sum of all numbers in the document?

# Your puzzle answer was 119433.

# --- Part Two ---

# Uh oh - the Accounting-Elves have realized that they double-counted everything red.

# Ignore any object (and all of its children) which has any property with the value "red". Do this only for objects ({...}), not arrays ([...]).

# [1,2,3] still has a sum of 6.
# [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
# {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
# [1,"red",5] has a sum of 6, because "red" in an array has no effect.
# Your puzzle answer was 68466.


# Made the leaderboard with this one! Came in 65th place, completing it in 18:53 after its release, despite being distracted a bit at the beginning.

# Alternative approach suggested early on the Reddit: just use Regex for Part One. (Part Two being trickier...)

require 'json'

def convert
	file = File.read("help12-objects.json")
	hash = JSON.parse(file)
	hash
end

def parse(data, count = 0)
	if data.is_a? Hash
		# unless data.has_value?("red") # For Part Two
			data.each do |k, v|
				count = parse(v, count)
			end
		# end  # For Part Two
	elsif data.is_a? Array
		data.each do |el|
			count = parse(el, count)
		end
	elsif data.is_a? Integer
		count += data
	end
	count
end 

p parse(convert)