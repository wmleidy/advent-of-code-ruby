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

### Other Approaches ###
# 1) Use built-in #succ! method instead of my #increment_letter
# 2) Another #increment_letter alternative: (n.to_i(36)+1).to_s(36).gsub('0', 'a')
# 3) Nifty and complete solution using Regexp.union and #each_cons:
  # s = 'cqjxjnds'
  # r = Regexp.union [*?a..?z].each_cons(3).map(&:join)
  # s.succ! until s[r] && s !~ /[iol]/ && s.scan(/(.)\1/).size > 1
  # p s
