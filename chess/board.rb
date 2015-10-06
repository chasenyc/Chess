require_relative 'piece.rb'
require 'byebug'

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

  def in_check?(color)
    king_pos = find_piece_positions(:king, color).first
    opp_positions = opponent_positions(color)
    opp_positions.any? do |position|
      self[position].moves.include?(king_pos)
    end
  end

  def checkmate?

  end

  def flip(color)
    color == :white ? :black : :white
  end

  def all_pieces
    [:rook, :knight, :bishop, :king, :queen, :pawn]
  end

  def opponent_positions(color)
    result = []
    all_pieces.each do |piece|
      result.concat(find_piece_positions(piece, flip(color)))
    end
    result
  end


  def find_piece_positions(type, color)
      pieces.select do |piece|
        piece.type == type && piece.color == color
      end.map { |piece| piece.pos }
  end

  def pieces
    grid.flatten.compact
  end

  private

    def generate_pieces
      #WHITE
      self[[0,0]] = Rook.new(  self, :rook  , :white, [0,0])
      self[[0,7]] = Rook.new(  self, :rook  , :white, [0,7])
      self[[0,1]] = Knight.new(self, :knight, :white, [0,1])
      self[[0,6]] = Knight.new(self, :knight, :white, [0,6])
      self[[0,2]] = Bishop.new(self, :bishop, :white, [0,2])
      self[[0,5]] = Bishop.new(self, :bishop, :white, [0,5])
      self[[0,3]] = King.new(  self, :king  , :white, [0,3])
      self[[0,4]] = Queen.new( self, :queen , :white, [0,4])
      #PAWNS
      8.times do |i|
        pos = [1,i]
        self[pos] = Pawn.new(  self, :pawn  , :white, pos)
      end


      #BLACK
      self[[7,0]] = Rook.new(  self, :rook  , :black, [7,0])
      self[[7,7]] = Rook.new(  self, :rook  , :black, [7,7])
      self[[7,1]] = Knight.new(self, :knight, :black, [7,1])
      self[[7,6]] = Knight.new(self, :knight, :black, [7,6])
      self[[7,2]] = Bishop.new(self, :bishop, :black, [7,2])
      self[[7,5]] = Bishop.new(self, :bishop, :black, [7,5])
      self[[7,3]] = King.new(  self, :king  , :black, [7,3])
      self[[7,4]] = Queen.new( self, :queen , :black, [7,4])
      #PAWNS
      8.times do |i|
        pos = [6,i]
        self[pos] = Pawn.new(  self, :pawn  , :black, pos)
      end
    end

    def inspect
    end
end
