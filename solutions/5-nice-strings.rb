# Part One
def nice_string?(str)
  vowels_count(str) >= 3 && doubles_okay?(str) && forbiddens_okay?(str)
end

def vowels_count(str)
  str.scan(/[aeiou]/).length
end

def doubles_okay?(str)
  !!str.match(/(.)\1/)
end

def forbiddens_okay?(str)
  !str.match(/ab|cd|pq|xy/)
end

def nice_strings_tabulator
  total = 0

  IO.foreach("../input/input5-nice-strings.txt") do |line|
    total += 1 if nice_string?(line)
  end
  total
end

# Part Two
def nice_string2?(str)
  has_pairs?(str) && has_mini_palindrome?(str)
end

def has_pairs?(str)
  !!str.match(/(..).*\1/)
end

def has_mini_palindrome?(str)
  !!str.match(/(.).\1/)
end

def nice_strings_tabulator2
  total = 0

  IO.foreach("../input/input5-nice-strings.txt") do |line|
    total += 1 if nice_string2?(line)
  end
  total
end

p nice_strings_tabulator
p nice_strings_tabulator2