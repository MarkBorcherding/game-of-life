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
    cells[index row, col] = :alive
  end

  def over_populated?(row, col)
    alive?(row, col) and living_neighbors(row, col) < 2
  end

  def surviving?(row, col)
    alive?(row, col) and living_neighbors(row, col).between?(2,3)
  end

  def overpopulated?(row,col)
    alive?(row, col) and living_neighbors(row, col) == 4
  end

  def reproduces?(row, col)
    dead?(row, col) and living_neighbors(row, col) == 3
  end

  def next_generation
    World.new(height, width).tap do |world|
      height.times do |h|
        width.times do |w|
          world.live!(h,w) if surviving?(h,w) or reproduces?(h,w)
        end
      end
    end
  end

  def cell(row, col)
    cells[index row, col]
  end

  def living_neighbors(row, col)
    neightbors(row, col).count { |cell| cell == :alive }
  end

  def neightbors(row, col)
    [above(row, col),
     left(row, col),
     right(row, col),
    below(row, col)]
  end

  def index(row, col)
    row * height + col
  end

  def above(row, col)
    cell(row-1, col) unless row == 0
  end

  def below(row, col)
    cell(row+1,col) unless row == @height - 1
  end

  def left(row, col)
    cell(row, col-1) unless col == 0
  end

  def right(row, col)
    cell(row, col+1) unless col == @width - 1
  end


end
