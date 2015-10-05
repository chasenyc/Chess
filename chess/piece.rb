class Piece

  attr_accessor :pos

  def initialize(type, color, pos)
    @type, @color, @pos = type, color, pos
  end

  def move_valid?(end_pos)
    true
    #TO do
  end

  def to_s

  end
end
