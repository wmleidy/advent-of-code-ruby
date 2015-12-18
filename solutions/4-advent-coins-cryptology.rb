# --- Day 4: The Ideal Stocking Stuffer ---

# Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically forward-thinking little girls and boys.

# To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins, you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.

# For example:

# If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...), and it is the lowest such number to do so.
# If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....

# --- Part Two ---

# Now find one that starts with six zeroes.



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

### Ruby solution from Reddit ###

# require 'openssl'

# for i in 1..10000000 do
#   md5 = OpenSSL::Digest::MD5.hexdigest('ckczppom' + i.to_s)
#   if md5 =~ /^000000/
#     p i
#     p md5
#     break
#   end
# end