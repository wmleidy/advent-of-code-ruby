# My SLOW solution (made considerably faster by using << instead of + to combined strings)
def look_and_say_wrapper(input, iterations = 40)
  iterations.times do |x|
    input = look_and_say(input)
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
      new_str << count.to_s
      new_str << prev
      count = 1
    else
      count += 1
    end
    prev = old_str[i]
    i += 1
  end
  new_str << count.to_s
  new_str << prev
  new_str.to_i
end

p look_and_say_wrapper(1321131112)
p look_and_say_wrapper(1321131112, 50)

### Someone else's very fast and very good solution ###
# input = '1321131112'

# 50.times do |count|
#   input = input.gsub(/(.)\1*/) { |s| s.size.to_s + s[0] }
#   puts "#{count + 1}: #{input.length}"
# end