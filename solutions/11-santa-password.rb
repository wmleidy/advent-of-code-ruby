# --- Day 11: Corporate Policy ---

# Santa's previous password expired, and he needs help choosing a new one.

# To help him remember his new password after the old one expires, Santa has devised a method of coming up with a password based on the previous one. Corporate policy dictates that passwords must be exactly eight lowercase letters (for security reasons), so he finds his new password by incrementing his old password string repeatedly until it is valid.

# Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so on. Increase the rightmost letter one step; if it was z, it wraps around to a, and repeat with the next letter to the left until one doesn't wrap around.

# Unfortunately for Santa, a new Security-Elf recently started, and he has imposed some additional password requirements:

# Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd doesn't count.
# Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are therefore confusing.
# Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.
# For example:

# hijklmmn meets the first requirement (because it contains the straight hij) but fails the second requirement requirement (because it contains i and l).
# abbceffg meets the third requirement (because it repeats bb and ff) but fails the first requirement.
# abbcegjk fails the third requirement, because it only has one double letter (bb).
# The next password after abcdefgh is abcdffaa.
# The next password after ghijklmn is ghjaabcc, because you eventually skip all the passwords that start with ghi..., since i is not allowed.
# Given Santa's current password (your puzzle input), what should his next password be?

# --- Part Two ---

# Santa's password expired again. What's the next one?

def find_new_password(str)
	until no_forbidden_letters?(str) && has_sequence?(str) && has_two_pairs?(str)
		str = increment_letter(str)
	end
	str
end

def increment_letter(str)
	pos = str.length - 1
	while str[pos] == "z"
		str[pos] = "a"
		pos -= 1
	end
	str[pos] = str[pos].next
	str
end

def no_forbidden_letters?(str)
	!/[ilo]/.match(str)
end

def has_sequence?(str)
	i = 0
	while i < str.length - 3
		if str[i+2] == str[i+1].next && str[i+2] == str[i].next.next
			return true
		else
			i += 1
		end
	end
	false
end

def has_two_pairs?(str)
	str.scan(/(.)\1/).length >= 2
end

input = "hxbxwxba"
p find_new_password(input)
p find_new_password(increment_letter(find_new_password(input)))

### Behold the power of Ruby...someone else's solution on Reddit ###
s = 'cqjxjnds'
r = Regexp.union [*?a..?z].each_cons(3).map(&:join)
s.succ! until s[r] && s !~ /[iol]/ && s.scan(/(.)\1/).size > 1
p s

# An alternative to incrementing with #succ or my method #increment_letter
# Not that much, I used (n.to_i(36)+1).to_s(36).gsub('0', 'a') to get the next string.
