# Historical note of little to no interest to anyone but me:
# Made the leaderboard...barely...in my final attempt to do so

def registers_io
  instructions = []

  IO.foreach("../input/input23-registers-computer.txt") do |line|
    data = line.chomp.split
    
    command = data[0]
    
    if data[1][-1] == ","
      target = data[1][0]
    elsif data[1][0] == "+" || data[1][0] == "-"
      target = data[1].to_i
    else
      target = data[1]
    end

    if data[2]
      instructions << [command, target, data[2][1..-1].to_i]
    else
      instructions << [command, target]
    end
  end

  instructions
end

def compute(instr)
  # regs = { "a" => 0, "b" => 0} # Part One
  regs = { "a" => 1, "b" => 0} # Part Two
  i = 0

  while i >= 0 && i < 49
    p regs
    command = instr[i][0]
    case command
    when "hlf"
      regs[instr[i][1]] /= 2
      i += 1
    when "tpl"
      regs[instr[i][1]] *= 3
      i += 1
    when "inc"
      regs[instr[i][1]] += 1
      i += 1
    when "jmp"
      i += instr[i][1]
    when "jie"
      regs[instr[i][1]].even? ? i += instr[i][2] : i += 1
    when "jio" # jump if ONE (not jump if odd)
      regs[instr[i][1]] == 1  ? i += instr[i][2] : i += 1
    end
  end
  regs["b"]
end

# Toggle the first two lines of #compute for Part One and Part Two
p compute(registers_io)

### Other Approaches ###

# 1) My original approach used instance variables because I thought it would be
#    the easiest way (cf. Day 7); but this wasn't true at all...as can be seen
#    in my refactored solution, which uses a registers hash
# 2) Input could be parsed using Regex, but meh...
