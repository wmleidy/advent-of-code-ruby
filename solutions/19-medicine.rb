# Historical note of little to no interest to anyone but me:
# Finished #4 on the leaderboard with a time of 28:02, but my "solution"
# for Part Two was only a preliminary, "naive" effort meant as a precursor to
# attempts to optimize with a repeated shuffle or sorting the substitutions
# array by descending length of second element. As it has no mechanism for
# optimization within it, I was quite surprised when it produced the answer.

subs = [
["Al","ThF"],
["Al","ThRnFAr"],
["B","BCa"],
["B","TiB"],
["B","TiRnFAr"],
["Ca","CaCa"],
["Ca","PB"],
["Ca","PRnFAr"],
["Ca","SiRnFYFAr"],
["Ca","SiRnMgAr"],
["Ca","SiTh"],
["F","CaF"],
["F","PMg"],
["F","SiAl"],
["H","CRnAlAr"],
["H","CRnFYFYFAr"],
["H","CRnFYMgAr"],
["H","CRnMgYFAr"],
["H","HCa"],
["H","NRnFYFAr"],
["H","NRnMgAr"],
["H","NTh"],
["H","OB"],
["H","ORnFAr"],
["Mg","BF"],
["Mg","TiMg"],
["N","CRnFAr"],
["N","HSi"],
["O","CRnFYFAr"],
["O","CRnMgAr"],
["O","HP"],
["O","NRnFAr"],
["O","OTi"],
["P","CaP"],
["P","PTi"],
["P","SiRnFAr"],
["Si","CaSi"],
["Th","ThCa"],
["Ti","BP"],
["Ti","TiTi"],
["e","HF"],
["e","NAl"],
["e","OMg"]
]

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

p find_possible_molecules(input, subs)

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
        end
        i += 1
      end
      # p [molecule, count]
    end
  end
  [molecule, steps]
end

# Very surprised this worked as there's no optimization built in (see preamble)
p distill_molecule(input, subs)

### Other Approaches, i.e. Approaches that Actually Optimize  ###

# ...coming after subreddit populates...