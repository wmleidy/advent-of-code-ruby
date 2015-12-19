def wrapping_paper(l, w, h)
  face1 = l * w
  face2 = w * h
  face3 = l * h
  extra = [face1, face2, face3].min
  2 * (face1 + face2 + face3) + extra
end

def ribbon(l, w, h)
  [perimeter(l,w), perimeter(w,h), perimeter(l,h)].min + volume(l, w, h)
end

def perimeter(side1, side2)
  2 * (side1 + side2)
end

def volume(l, w, h)
  l * w * h
end

def wrapping_io
  paper_total = 0
  ribbon_total = 0

  IO.foreach("../input/input2-wrapping-paper.txt") do |line|
    dimensions = line.split("x")
    length = dimensions[0].to_i
    width = dimensions[1].to_i
    height = dimensions[2].to_i
    paper_total  += wrapping_paper(length, width, height)
    ribbon_total += ribbon(length, width, height)
  end
  [paper_total, ribbon_total]
end

p wrapping_io