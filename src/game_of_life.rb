class World

  attr_accessor :height, :width, :cells

  def initialize(height, width)
    self.height = height
    self.width = width
    self.cells = Array.new height * width
  end

  def dead?(row, col)
    !alive? row, col
  end

  def alive?(row, col)
    cell(row, col) == :alive
  end

  def live!(row, col)
    cells[index(row, col)] = :alive
  end

  def over_populated?(row, col)
    alive?(row, col) and living_neighbors(row, col) < 2
  end

  def surviving?(row, col)
    alive?(row, col) and living_neighbors(row, col).between?(2,3)
  end

  def overpopulated?(row,col)
    alive?(row, col) and living_neighbors(row, col) > 3
  end

  def reproduces?(row, col)
    dead?(row, col) and living_neighbors(row, col) == 3
  end

  def next_generation
    World.new(height, width).tap do |world|
      height.times do |r|
        width.times do |c|
          world.live!(r,c) if surviving?(r,c) or reproduces?(r,c)
        end
      end
    end
  end

  def display
    s = []
    height.times do |r|
      width.times do |c|
        if alive? r,c
          s.push 'o'
        else
          s.push '.'
        end
      end
      s.push "\n"
    end
    s.join
  end

  def run(iterations)
    w = self
    iterations.times do
      w = w.next_generation
    end
    w
  end


  def cell(row, col)
    cells[index(row, col)]
  end

  def living_neighbors(row, col)
    neightbors(row, col).count { |cell| cell == :alive }
  end

  def neightbors(row, col)
    [above(row, col),
     left(row, col),
     right(row, col),
    below(row, col),
    upper_left(row, col),
    upper_right(row, col),
    lower_left(row, col),
    lower_right(row, col)]
  end

  def index(row, col)
    (row * width) + col
  end

  def above(row, col)
    cell(row-1, col) if above? row
  end

  def below(row, col)
    cell(row+1,col) if below? row
  end

  def left(row, col)
    cell(row, col-1) if left? col
  end

  def right(row, col)
    cell(row, col+1) if right? col
  end

  def lower_left(row, col)
    cell(row+1, col-1) if left?(col) and below?(row)
  end

  def lower_right(row, col)
    cell(row+1, col+1) if right?(col) and below?(row)
  end

  def upper_left(row, col)
    cell(row-1, col-1) if left?(col) and above?(row)
  end

  def upper_right(row, col)
    cell(row-1, col+1) if right?(col) and above?(row)
  end

  def below?(row)
    row < height-1
  end

  def above?(row)
    row > 0
  end

  def left?(col)
    col > 0
  end

  def right?(col)
    col < width - 1
  end




end
