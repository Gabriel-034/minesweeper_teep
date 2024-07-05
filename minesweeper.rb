class Minesweeper
    attr_accessor :board

    def initialize(board)
        @board = board
        board.seed_bombs
        board.calculate_adjacent_bombs
    end

    def play
      until won? || lost?
        board.render
        take_turn
      end

      if won?
        puts "Vous avez gagné!"
      elsif lost?
        puts "BOOM! Vous avez perdu!"
      end
    end

    def take_turn
        x, y = nil, nil

        loop do
        puts "Entrez les coordonnées de la cellule à ouvrir ou à marquer (par exemple, '3,4')."
        input = gets.chomp.split(",").map(&:strip)
        if input.size == 2 && input.all? { |i| i =~ /^\d+$/ }
        x, y = input.map(&:to_i)

        if coordinates_inboard?(x, y)
            break
          else
            puts "Coordonnées invalides. Veuillez entrer des coordonnées valides."
          end
        else
            puts "Entrée invalide. Veuillez entrer deux chiffres séparés par une virgule."
          end
        end

        cell = @board.grid[x][y]

        if cell.revealed
            puts "Cette cellule est déjà révélée."
            return
        end

        if cell.flagged
            puts "entrez 'u' pour révéler la case marquée ou 'm' pour déflagger la case"
          else
            puts "Voulez-vous ouvrir ou marquer cette cellule ? Entrez 'o' pour ouvrir, 'm' pour marquer."
          end

          action = gets.chomp

        if action == 'o' && !cell.flagged
          if @board.grid[x][y].bomb
            @board.grid[x][y].revealed = true
            board.render
            puts "BOOM! Vous avez perdu!"
            exit
          else
            reveal(x, y)
          end
        elsif action == 'm'
          @board.grid[x][y].flagged = !@board.grid[x][y].flagged
    elsif action == 'u' && @board.grid[x][y].flagged
        @board.grid[x][y].flagged = false
        reveal(x, y)
      end
    end

    def coordinates_inboard?(x, y)
        x.between?(0, @board.height - 1) && y.between?(0, @board.width - 1)
      end

      def already_used?(x, y)
        cell = @board.grid[x][y]
        cell.revealed || cell.flagged
      end

      def reveal(x, y)
        cell = @board.grid[x][y]
        return if cell.revealed

        cell.reveal
    end

      def won?
        @board.grid.flatten.none? { |cell| cell.revealed == false && cell.bomb == false }
      end

      def lost?
        @board.grid.flatten.any? { |cell| cell.revealed == true && cell.bomb == true }
      end
    end

require_relative 'cell'
require_relative 'board'
require_relative 'minesweeper'

if ARGV.empty?
    height, width, mines = 5, 5, 5
elsif ARGV.size != 3
    puts "Usage: #{$PROGRAM_NAME} height width mines"
    exit
else
  height, width, mines = ARGV.map(&:to_i)
end

  if height <= 0 || width <= 0 || mines < 0 || mines > height * width
    puts "Invalid parameters. Ensure height and width are positive integers and mines are non-negative and do not exceed the number of cells."
    exit
  end

  ARGV.clear

board = Board.new(height, width, mines)
game = Minesweeper.new(board)
game.play
