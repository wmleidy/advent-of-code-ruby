class Sue
  attr_reader :number, :children, :cats, :samoyeds, :pomeranians, :akitas, :vizslas, :goldfish, :trees, :cars, :perfumes

  def initialize(number, options = {})
    @number = number
    @children = options["children"] || "unknown"
    @cats = options["cats"] || "unknown"
    @samoyeds = options["samoyeds"] || "unknown"
    @pomeranians = options["pomeranians"] || "unknown"
    @akitas = options["akitas"] || "unknown"
    @vizslas = options["vizslas"] || "unknown"
    @goldfish = options["goldfish"] || "unknown"
    @trees = options["trees"] || "unknown"
    @cars = options["cars"] || "unknown"
    @perfumes = options["perfumes"] || "unknown"
  end
end

# Refactored to Regex with ideas from Reddit
def sue_io
  sues = []

  IO.foreach("../input/input16-aunt-sue.txt") do |line|
    results = line.chomp.match(/Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)/)
    number = results[1].to_i
    h = {}
    h[results[2]] = results[3].to_i
    h[results[4]] = results[5].to_i
    h[results[6]] = results[7].to_i
    s = Sue.new(number, h) 
    sues << s
  end

  sues
end

def find_matching_sue(arr)
  conditions = {
    children: 3,
    cats: 7,
    samoyeds: 2,
    pomeranians: 3,
    akitas: 0,
    vizslas: 0,
    goldfish: 5,
    trees: 3,
    cars: 2,
    perfumes: 1
  }
  # Part One
  # arr.each do |sue|
  #   return sue if the_right_sue?(sue, conditions)
  # end

  # Part Two
  arr.each do |sue|
    return sue if the_right_sue_deux?(sue, conditions)
  end

end

def the_right_sue?(sue, conditions)
  conditions.each do |k, v|
    if v != sue.send(k)
      return false unless sue.send(k) == "unknown"
    end
  end
  true
end

# Note: this is very, very far from being DRY, but it works
def the_right_sue_deux?(sue, conditions)
  (sue.children == "unknown" || conditions[:children] == sue.children) &&
  (sue.cats == "unknown" || conditions[:cats] < sue.cats) &&
  (sue.samoyeds == "unknown" || conditions[:samoyeds] == sue.samoyeds) &&
  (sue.pomeranians == "unknown" || conditions[:pomeranians] > sue.pomeranians) &&
  (sue.akitas == "unknown" || conditions[:akitas] == sue.akitas) &&
  (sue.vizslas == "unknown" || conditions[:vizslas] == sue.vizslas) &&
  (sue.goldfish == "unknown" || conditions[:goldfish] > sue.goldfish) &&
  (sue.trees == "unknown" || conditions[:trees] < sue.trees) &&
  (sue.cars == "unknown" || conditions[:cars] == sue.cars) &&
  (sue.perfumes == "unknown" || conditions[:perfumes] == sue.perfumes)
end

p find_matching_sue(sue_io)
# Toggle parts commented out in #find_matching_sue to get Part One / Part Two answers