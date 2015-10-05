require_relative 'piece.rb'

class ChessError < StandardError
end

class Board
  attr_reader :grid

  def initialize
    populate_board
  end

  def populate_board
    @grid = Array.new(8) { Array.new(8) }
    generate_pieces
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos,mark)
    x, y = pos
    @grid[x][y] = mark
  end

  def move(start_pos, end_pos)
    #Check if pieces are there
    raise ChessError.new("No piece at start position") if self[start_pos].nil?
    raise ChessError.new("Not valid move") unless self[start_pos].move_valid?(end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[end_pos].pos = end_pos
  end

    def in_bounds?(pos)
      pos[0].between?(0, 7) && pos[1].between?(0, 7)
    end

  private

    def generate_pieces
      #WHITE
      self[[0,0]] = Piece.new(self, :rook  , :white, [0,0])
      self[[0,7]] = Piece.new(self, :rook  , :white, [0,7])
      self[[0,1]] = Piece.new(self, :knight, :white, [0,1])
      self[[0,6]] = Piece.new(self, :knight, :white, [0,6])
      self[[0,2]] = Piece.new(self, :bishop, :white, [0,2])
      self[[0,5]] = Piece.new(self, :bishop, :white, [0,5])
      self[[0,3]] = Piece.new(self, :king  , :white, [0,3])
      self[[0,4]] = Piece.new(self, :queen , :white, [0,4])
      #PAWNS
      8.times do |i|
        pos = [1,i]
        self[pos] = Piece.new(self, :pawn, :white, pos)
      end


      #BLACK
      self[[7,0]] = Piece.new(self, :rook  , :black, [7,0])
      self[[7,7]] = Piece.new(self, :rook  , :black, [7,7])
      self[[7,1]] = Piece.new(self, :knight, :black, [7,1])
      self[[7,6]] = Piece.new(self, :knight, :black, [7,6])
      self[[7,2]] = Piece.new(self, :bishop, :black, [7,2])
      self[[7,5]] = Piece.new(self, :bishop, :black, [7,5])
      self[[7,3]] = Piece.new(self, :king  , :black, [7,3])
      self[[7,4]] = Piece.new(self, :queen , :black, [7,4])
      #PAWNS
      8.times do |i|
        pos = [6,i]
        self[pos] = Piece.new(self, :pawn, :black, pos)
      end
    end

    def inspect
    end
end
