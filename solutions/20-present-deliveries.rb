# Part One - refactored version based on Part Two
# (it's much faster than my original algorithm which looked at divisors)
def find_house(target)
  h = Hash.new(0)
  i = 1
  while i <= 1_000_000
    j = i
    while j <= 1_000_000
      h[j] += i * 10
      j += i
    end
    i += 1
  end
  h.each do |k, v|
    return [k, v] if v >= target
  end
end

# Part Two
def find_house_two(target)
  h = Hash.new(0)
  i = 1
  while i <= 1_000_000
    j = 1
    while j <= 50
      h[i * j] += i * 11 unless i * j > 1_000_000
      j += 1
    end
    i += 1
  end
  h.each do |k, v|
    return [k, v] if v >= target
  end
end

input = 34_000_000
p find_house(input)
p find_house_two(input)

### Other Ideas I Had While Waiting for Divisor-based Algorithm to Finish ###

# IDEA A) - optimizing the divisor-based search

  # 1) check to see if valid divisor up until house_number/2 (was actually in my 1st implementation)
  # 2) use math to choose a reasonable starting house (e.g. 500_000 instead of 1)
  # 3) instead of stepping through house numbers by ones, step through them by 20, figuring
  #    that 2 * 2 * 5 will be three of the prime factors involved in the solution

# IDEA B) - leveraging prime factors to reduce modulus comparisons

  # 1) generate list of prime numbers up to ~1_000_000
  # 2) quickly find all prime factors of number n
  # 3) find subsets of those prime factors
  # 4) narrow down to unique subsets
  # 5) for each unique subset, inject(:*)
  # 6) sum up with inject(:+) * 10 and add 10 (for elf #1)
  # 7) if >= than target number, return
  #    else go forward to next number n

# IDEA C) - working with sets of prime numbers

  # 1) generate list of prime numbers up to ~17
  # 2) make arrays of length 8-12 to be populated with prime numbers (smaller ones first)
  # 3) use subset method in IDEA A to calculate the number of presents dropped off
  # 4) if greater than target, find the corresponding number by inject(:*) on largest subset,
  #    then add result to a list of acceptable answers
  # 5) after recursively checking all arrays of prime numbers of length 8-12, find the
  #    minimum number in the list of acceptable answers

# These three ideas were all rendered moot after I solved Part One, because the constraints
# given in Part Two naturally led me to come up with a hash-based approach, which, as it turned
# out is the most efficient solution to Part One in terms of time complexity.