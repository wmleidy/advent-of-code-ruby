require 'digest'

def find_md5_hex(md5_hash_fragment, num_of_zeros)
  i = 0
  target = "0" * num_of_zeros
  while true
    test_hash = md5_hash_fragment + i.to_s
    test_hex  = Digest::MD5.hexdigest(test_hash)
    return i if test_hex[0...num_of_zeros] == target
    i += 1
  end
end

input = "ckczppom"
p find_md5_hex(input, 5)
p find_md5_hex(input, 6)

### Other Approaches ###
# 1) Use Regex to look for match of zeroes in the string.