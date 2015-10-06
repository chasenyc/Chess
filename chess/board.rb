require_relative 'piece.rb'
require 'byebug'

class ChessError < StandardError
end

class Board
  attr_reader :grid
  attr_accessor :current_player

  def initialize()
    populate_board
    @current_player = :white
  end

  def populate_board
    @grid = Array.new(8) { Array.new(8) }
    generate_pieces
  end

  def flip_player!
    self.current_player = flip_color(current_player)
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

    raise ChessError.new("You are in check with this move") if self[start_pos].move_into_check?(end_pos)

    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[end_pos].pos = end_pos
  end

  def move!(start_pos, end_pos)
    raise ChessError.new("No piece at start position") if self[start_pos].nil?
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
    self[end_pos].pos = end_pos
  end

  def in_bounds?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end

  def in_check?(color)
    king_pos = find_piece_positions(:king, color).first
    opp_positions = player_positions(flip_color(color))
    opp_positions.any? do |position|
      self[position].moves.include?(king_pos)
    end
  end

  def checkmate?
    in_check?(current_player) && no_valid_moves?(current_player)
  end

  def flip_color(color)
    color == :white ? :black : :white
  end

  def all_pieces
    [:rook, :knight, :bishop, :king, :queen, :pawn]
  end

  def player_positions(color)
    result = []
    all_pieces.each do |piece|
      result.concat(find_piece_positions(piece, color))
    end
    result
  end

  def no_valid_moves?(color)
    player_positions(color).each do |pos|
      self[pos].moves.each do |new_pos|
        return false if !(self[pos].move_into_check?(new_pos))
      end
    end
    true
  end


  def find_piece_positions(type, color)
      pieces.select do |piece|
        piece.type == type && piece.color == color
      end.map { |piece| piece.pos }
  end

  def pieces
    grid.flatten.compact
  end

  def deep_dup
    new_board = Board.new
    grid.each_index do |row_idx|
      grid[row_idx].each_with_index do |piece, col_idx|
        new_board[[row_idx,col_idx]] = piece.deep_dup(new_board) unless piece.nil?
        new_board[[row_idx,col_idx]] = nil if piece.nil?
      end
    end
    new_board
  end

  private

    def generate_pieces
      #WHITE
      self[[0,0]] = Rook.new(  self, :rook  , :black, [0,0])
      self[[0,7]] = Rook.new(  self, :rook  , :black, [0,7])
      self[[0,1]] = Knight.new(self, :knight, :black, [0,1])
      self[[0,6]] = Knight.new(self, :knight, :black, [0,6])
      self[[0,2]] = Bishop.new(self, :bishop, :black, [0,2])
      self[[0,5]] = Bishop.new(self, :bishop, :black, [0,5])
      self[[0,4]] = King.new(  self, :king  , :black, [0,4])
      self[[0,3]] = Queen.new( self, :queen , :black, [0,3])
      #PAWNS
      8.times do |i|
        pos = [1,i]
        self[pos] = Pawn.new(  self, :pawn  , :black, pos)
      end


      #BLACK
      self[[7,0]] = Rook.new(  self, :rook  , :white, [7,0])
      self[[7,7]] = Rook.new(  self, :rook  , :white, [7,7])
      self[[7,1]] = Knight.new(self, :knight, :white, [7,1])
      self[[7,6]] = Knight.new(self, :knight, :white, [7,6])
      self[[7,2]] = Bishop.new(self, :bishop, :white, [7,2])
      self[[7,5]] = Bishop.new(self, :bishop, :white, [7,5])
      self[[7,4]] = King.new(  self, :king  , :white, [7,4])
      self[[7,3]] = Queen.new( self, :queen , :white, [7,3])
      #PAWNS
      8.times do |i|
        pos = [6,i]
        self[pos] = Pawn.new(  self, :pawn  , :white, pos)
      end
    end

    def inspect
    end
end
