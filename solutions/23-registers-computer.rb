# Historical note of little to no interest to anyone but me:
# Final time I attempt to make the leaderboard: finished #93 and spent a fair
# bit of time debugging the "jio" is actually "jump if ONE" and not "jump if odd"
# as one might expect it to be.

def registers_io
  instructions = []

  IO.foreach("../input/input23-registers-computer.txt") do |line|
    data = line.chomp.split
    
    command = data[0]
    
    if data[1][-1] == ","
      target = data[1][0]
    elsif data[1][0] == "+"
      target = data[1][1..-1].to_i
    elsif data[1][0] == "-"
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

def compute(regs)
  # @a = 0 # Part One
  @a = 1 # Part Two
  @b = 0
  i = 0

  while i >= 0 && i < 49
    command = regs[i][0]
    p [i, @a, @b]
    case command
    when "hlf"
      instance_variable_set("@#{regs[i][1]}", instance_variable_get("@#{regs[i][1]}") / 2)
      i += 1
    when "tpl"
      instance_variable_set("@#{regs[i][1]}", instance_variable_get("@#{regs[i][1]}") * 3)
      i += 1
    when "inc"
      instance_variable_set("@#{regs[i][1]}", instance_variable_get("@#{regs[i][1]}") + 1)
      i += 1
    when "jmp"
      i += regs[i][1]
    when "jio"
      if instance_variable_get("@#{regs[i][1]}") == 1
        i += regs[i][2]
      else
        i += 1
      end
    when "jie"
      if instance_variable_get("@#{regs[i][1]}") % 2 == 0
        i += regs[i][2]
      else
        i += 1
      end
    end
  end
  @b
end

# Toggle the first two lines of #compute for Part One and Part Two
p compute(registers_io)

### Other Approaches ###

# coming soon...but obviously a little Regex-based refactoring of the IO would be nice...
# ...also, there has to be a way to do this without using instance variables...
