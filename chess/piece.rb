require 'colorize'

class Piece

  DISPLAY_HASH = {
    :pawn   => "\u265f",
    :knight => "\u265e",
    :bishop => "\u265d",
    :rook   => "\u265c",
    :queen  => "\u265b",
    :king   => "\u265a",
  }

  attr_accessor :pos

  def initialize(board, type, color, pos)
    @board, @type, @color, @pos = board, type, color, pos
  end

  def move_valid?(end_pos)
    true
    #TO do
  end

  def to_s
    " #{DISPLAY_HASH[@type]}".colorize(@color)
  end
end

class SlidingPiece < Piece
  def moves(*direction)
    result = []
    result += straight_moves if direction.include?(:straight)
    result += diagonal_moves if direction.include?(:diagonal)
  end

  def straight_moves
    result = []
    8.times do |col|
      result << [pos[0], col] unless col == pos[1]
    end
    8.times do |row|
      result << [row, pos[1]] unless row == pos[0]
    end
    result
  end

  def diagonal_moves
    result = []
    8.times do |i|
      8.times do |j|
          result << [i,j] if i+j == pos.inject(:+) ||
                             i-j == pos.inject(:-)
      end
    end
    result.delete(pos)
  end
end

class Queen < SlidingPiece

end

class Rook < SlidingPiece

end

class Bishop < SlidingPiece

end

class SteppingPiece < Piece

end

class Knight < SteppingPiece

end

class King < SteppingPiece

end

class Pawn < Piece

end
