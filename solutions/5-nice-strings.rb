# --- Day 5: Doesn't He Have Intern-Elves For This? ---

# Santa needs help figuring out which strings in his text file are naughty or nice.

# A nice string is one with all of the following properties:

# It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
# It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
# It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
# For example:

# ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
# aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
# jchzalrnumimnmhp is naughty because it has no double letter.
# haegwjzuvuyypxyu is naughty because it contains the string xy.
# dvszwmarrgswjxmb is naughty because it contains only one vowel.

# --- Part Two ---

# Realizing the error of his ways, Santa has switched to a better model of determining whether a string is naughty or nice. None of the old rules apply, as they are all clearly ridiculous.

# Now, a nice string is one with all of the following properties:

# It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
# It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
# For example:

# qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly one letter between them (zxz).
# xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though the letters used by each rule overlap.
# uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
# ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears twice.
# How many strings are nice under these new rules?

# Part 1
def nice_string_checker(str)
	number_of_vowels = str.scan(/[aeiou]/).length
	doubles_okay = double_letter_check(str)
	forbiddens_okay = forbidden_substring_check(str)
	if number_of_vowels >= 3 && doubles_okay && forbiddens_okay
		true
	else
		false
	end
end

def double_letter_check(str)
	i = 1
	while i <= str.length
		return true if str[i - 1] == str[i]
		i += 1
	end
	false
end

def forbidden_substring_check(str)
	if /ab/.match(str) || /cd/.match(str) || /pq/.match(str) || /xy/.match(str)
		false
	else
		true
	end
end

def nice_strings_io
	total = 0

	IO.foreach("help5-nice-strings.txt") do |line|
		total += 1 if nice_string_checker(line)
	end
	total
end

p nice_strings_io

def nice_string_checker2(str)
	pairs_okay = pairs_check(str)
	palindrome_okay = mini_palindrome_check(str)
	pairs_okay && palindrome_okay
end

def pairs_check(str)
	i = 0
	while i < str.length - 1
		pair = str[i..i+1]
		j = i + 2
		while j < str.length - 1
			return true if pair == str[j..j+1]
			j += 1
		end
		i += 1
	end
	false
end

def mini_palindrome_check(str)
	i = 0
	while i < str.length - 2
		letter = str[i]
		return true if letter == str[i+2]
		i += 1
	end
	false
end

def nice_strings_io2
	total = 0

	IO.foreach("help5-nice-strings.txt") do |line|
		total += 1 if nice_string_checker2(line)
	end
	total
end

p nice_strings_io2

### Much more compact Ruby ###
# input = File.readlines('input5.txt').map { |l| l.chomp }
# # Part One
# input.inject(0) { |c,s| (s.scan(/ab|cd|pq|xy/).length == 0) && (s.scan(/[aeiou]/).length > 2) && (s.scan(/(.)\1/).length > 0) && c+=1; c }
# # Part Two
# input.inject(0) { |c,s| (s.scan(/(..).*\1/).length > 0) && (s.scan(/(.).\1/).length > 0) && c+=1; c }

### another Regexp thing in Ruby ###

# strings = File.read('05-strings.txt').split("\n")
# nice_strings = 0
# strings.each do |s|
#   if s =~ /(\w)\1+/ && s =~ /.*[aeiou].*[aeiou].*[aeiou].*/ && s !~ /.*ab|cd|pq|xy.*/
#     nice_strings += 1
#   end
# end

# puts "Nice: #{nice_strings}"