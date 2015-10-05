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

  STRAIGHT_STEP = [
    [ 0,  1],
    [ 0, -1],
    [ 1,  0],
    [-1,  0]
  ]

  DIAGONAL_STEP = [
    [ 1,  1],
    [ 1, -1],
    [-1,  1],
    [-1, -1]
  ]

  KNIGHT_STEP = [
    [ 1,  2],
    [ 1, -2],
    [-1,  2],
    [-1, -2],
    [ 2,  1],
    [ 2, -1],
    [-2,  1],
    [-2, -1]
  ]

  attr_reader :color
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
    result += valid_moves(STRAIGHT_STEP) if direction.include?(:straight)
    result += valid_moves(DIAGONAL_STEP) if direction.include?(:diagonal)

    result
  end

  def valid_moves(move_steps)
    result = []

    move_steps.each do |step|
      new_pos = [(step[0]+pos[0]),(step[1]+pos[1])]

      while @board.in_bounds?(new_pos) &&
           @board[new_pos].nil?
        result << new_pos
        new_pos = [(step[0]+new_pos[0]),(step[1]+new_pos[1])]
      end

      if @board[new_pos].nil?
      else

        result << new_pos if @board[new_pos].color != self.color
      end
    end

    result
  end
end

class Queen < SlidingPiece

  def moves
    super(:diagonal, :straight)
  end
end

class Rook < SlidingPiece

  def moves
    super(:straight)
  end
end

class Bishop < SlidingPiece

  def moves
    super(:diagonal)
  end
end

class SteppingPiece < Piece

  def moves(step_type)
    result = []
    result += valid_moves(KNIGHT_STEP) if step_type == :knight

  end

  def valid_moves(move_steps)
    result = []
    move_steps.each do |step|
      new_pos = [(step[0]+pos[0]),(step[1]+pos[1])]
      result << new_pos if @board.in_bounds?(new_pos) &&
                (@board[new_pos].nil? || @board[new_pos].color != color)
    end
    result
  end
end

class Knight < SteppingPiece
  def moves
    super(:knight)
  end
end

class King < SteppingPiece

end

class Pawn < Piece

end
