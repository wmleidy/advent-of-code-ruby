# Historical note of little to no interest to anyone but me:
# Finished #4 on the leaderboard with a time of 28:02, but my "solution"
# for Part Two was only a preliminary, "naive" effort meant as a precursor to
# attempts to optimize with a repeated shuffle or sorting the substitutions
# array by descending length of second element. As it has no mechanism for
# optimization within it, I was quite surprised when it produced the answer.
# (For explanation as to why: see below.)

def substitutions_io
  subs = []

  IO.foreach("../input/input19-medicine.txt") do |line|
    data = line.chomp.split(" => ")
    subs << data
  end

  subs
end

# Part One
def find_possible_molecules(molecule, substitutions)
  all_possibilities = []
  substitutions.each do |substitution|
    sub = substitution[0]
    target_length = sub.length
    i = 0
    while i <= molecule.length - target_length
      if molecule[i...i+target_length] == sub
        new_mole = molecule[0...i] + substitution[1] + molecule[i+target_length..-1]
        all_possibilities << new_mole
      end
      i += 1
    end
  end
  all_possibilities.uniq.length
end

input = "CRnCaCaCaSiRnBPTiMgArSiRnSiRnMgArSiRnCaFArTiTiBSiThFYCaFArCaCaSiThCaPBSiThSiThCaCaPTiRnPBSiThRnFArArCaCaSiThCaSiThSiRnMgArCaPTiBPRnFArSiThCaSiRnFArBCaSiRnCaPRnFArPMgYCaFArCaPTiTiTiBPBSiThCaPTiBPBSiRnFArBPBSiRnCaFArBPRnSiRnFArRnSiRnBFArCaFArCaCaCaSiThSiThCaCaPBPTiTiRnFArCaPTiBSiAlArPBCaCaCaCaCaSiRnMgArCaSiThFArThCaSiThCaSiRnCaFYCaSiRnFYFArFArCaSiRnFYFArCaSiRnBPMgArSiThPRnFArCaSiRnFArTiRnSiRnFYFArCaSiRnBFArCaSiRnTiMgArSiThCaSiThCaFArPRnFArSiRnFArTiTiTiTiBCaCaSiRnCaCaFYFArSiThCaPTiBPTiBCaSiThSiRnMgArCaF"

p find_possible_molecules(input, substitutions_io)

# Part Two
def distill_molecule(molecule, substitutions)
  steps = 0
  until molecule == "e"
    substitutions.each do |substitution|
      sub = substitution[1]
      target_length = sub.length
      i = 0
      while i <= molecule.length - target_length
        if molecule[i...i+target_length] == sub
          molecule = molecule[0...i] + substitution[0] + molecule[i+target_length..-1]
          steps += 1
          # p [molecule, steps] # to check progress
        end
        i += 1
      end
    end
  end
  [molecule, steps]
end

p distill_molecule(input, substitutions_io)
# Reading the explanation below makes me think that my Part Two answer would be more
# robust if I worked backwards through the string and/or checked the longest subs first

### Other Approaches ###

# Reddit users Andrew "Speed Demon" Skalski and CtiTheKing figured the essence out.

# Here is CtiTheKing's concise explanation:

# Actually, on second analysis, technically the second half didn't require any code. Here's why:
# All of the rules are of one of the following forms:
# α => βγ
# α => βRnγAr
# α => βRnγYδAr
# α => βRnγYδYεAr
# As Rn, Ar, and Y are only on the left side of the equation, one merely only needs to compute
# NumSymbols - #Rn - #Ar - 2 * #Y - 1

# Subtract of #Rn and #Ar because those are just extras. Subtract two times #Y because we get
# rid of the Ys and the extra elements following them. Subtract one because we start with "e".

# In other words, there is only one pathway that will work and the request for
# "fewest number of steps" was a red herring meant to throw us off the scent and
# lead us down the pathways of greedy algorithms, BFS, DFS, CYK, etc.