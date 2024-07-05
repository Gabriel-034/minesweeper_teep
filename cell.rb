class Cell
  attr_accessor :bomb, :revealed, :flagged, :adjacent_bombs

  def initialize
    @bomb = false
    @revealed = false
    @flagged = false
    @adjacent_bombs = 0
  end

  def to_s
    return "M" if flagged
    return "*" if !revealed
    return adjacent_bombs.to_s if !bomb && revealed
    return "X" if bomb && revealed
    "*"
  end

  def reveal
    self.revealed = true
  end
end
