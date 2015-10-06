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

  KING_STEP = [
    [ 0,  1],
    [ 0, -1],
    [ 1,  1],
    [ 1, -1],
    [-1,  1],
    [-1, -1],
    [ 1,  0],
    [-1,  0]
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

  def sum_positions(pos, new_pos)
    [(pos[0]+new_pos[0]), (pos[1]+new_pos[1])]
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
      new_pos = sum_positions(pos,step)

      while @board.in_bounds?(new_pos) &&
           @board[new_pos].nil?
        result << new_pos
        new_pos = sum_positions(step, new_pos)
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
    result += valid_moves(KING_STEP)   if step_type == :king

  end

  def valid_moves(move_steps)
    result = []
    move_steps.each do |step|
      new_pos = sum_positions(step,pos)
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
  def moves
    super(:king)
  end
end

class Pawn < Piece
  def moves
    steps = []

    if color == :white

      steps << [1, 0] if @board[sum_positions([1, 0], pos)].nil?

      steps << [2, 0] if pos[0] == 1 && !steps.empty? &&
                      @board[sum_positions([2, 0], pos)].nil?

      white_pawn_strike = [[1,-1],[1,1]]
      white_pawn_strike.each do |strike|
        new_pos = sum_positions(pos,strike)
          steps << strike if @board[new_pos].is_a?(Piece) &&
                             @board[new_pos].color == :black
      end
    else

      steps << [-1, 0] if @board[sum_positions([-1, 0], pos)].nil?

      steps << [-2, 0] if pos[0] == 6 && !steps.empty? &&
                      @board[sum_positions([-2, 0], pos)].nil?

      black_pawn_strike = [[-1,-1],[-1,1]]
      black_pawn_strike.each do |strike|
        new_pos = sum_positions(pos,strike)
          steps << strike if @board[new_pos].is_a?(Piece) &&
                             @board[new_pos].color == :black
      end
    end

    steps.map { |step| sum_positions(step,pos) }
  end
end
