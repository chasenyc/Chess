require_relative 'board'
require_relative 'piece'
require 'colorize'
require_relative 'cursorable'

class Display
  include Cursorable

  attr_reader :board, :cursor_pos, :selected

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end

  def render
    system('clear')
    square_color = :light_white
    8.times do |row|
      8.times do |col|
        pos = [row, col]
        if @board[pos].nil?
          square = "   ".colorize(:background => square_color)
        else
          square = "#{@board[pos].to_s} ".colorize(:background => square_color)
        end

        if @cursor_pos == pos
          if !@selected
            print square.colorize(:background => :red)
          elsif @selected
            print square.colorize(:background => :green)
          end
        else
          print square
        end

        square_color == :light_black ? square_color = :light_white : square_color = :light_black
      end
      print "\n"
      square_color == :light_black ? square_color = :light_white : square_color = :light_black
    end
    nil
  end

  def play(start_pos = nil)
    render
    #game_over if @board.checkmate?
    #@board.in_check?
    puts "START POS: #{start_pos}"

    while get_input.nil?
      @board[@cursor_pos]
      render
      puts "START POS: #{start_pos}"
    end

    if !@selected && @board[@cursor_pos].is_a?(Piece)
      @selected = true
      play(@cursor_pos)
    elsif @selected

      if @board[start_pos].moves.include?(@cursor_pos)
        @board.move(start_pos, @cursor_pos)
        @board.flip_player!
        @selected = false
      end

    end

    @selected = false
    play(start_pos)
  end

  def inspect

  end


end


# if __FILENAME__ = $PROGRAM_NAME
#
#   b = Board.new
#   d = Display.new(b)
#
# end
