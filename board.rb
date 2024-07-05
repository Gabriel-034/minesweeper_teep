class Board
  attr_accessor :grid, :height, :width

  def initialize(height, width, mines)
    @height = height
    @width = width
    @mines = mines
    @grid = Array.new(height) { Array.new(width) { Cell.new } }
    srand
    seed_bombs
    calculate_adjacent_bombs
  end

  def seed_bombs
    bombs_placed = 0
    while bombs_placed < @mines
      rand_row = rand(0...@height)
      rand_col = rand(0...@width)
      next if @grid[rand_row][rand_col].bomb

      @grid[rand_row][rand_col].bomb = true
      bombs_placed += 1
    end
  end

  def calculate_adjacent_bombs
    @grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        cell.adjacent_bombs = adjacent_bomb_count(i, j) unless cell.bomb
      end
    end
  end

  def adjacent_bomb_count(x, y)
    count = 0
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        next if dx == 0 && dy == 0
        new_x, new_y = x + dx, y + dy
        count += 1 if coordinates_inboard?(new_x, new_y) && @grid[new_x][new_y].bomb
      end
    end
    count
  end

  def coordinates_inboard?(x, y)
    x.between?(0, @height - 1) && y.between?(0, @width - 1)
  end

  def render
    @grid.each do |row|
      puts row.map { |cell| "| #{cell} " }.join("|") + "|"
    end
  end
end
