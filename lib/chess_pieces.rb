# frozen_string_literal: true

# Collection of chess piece classes
# Base class ChessPiece contains general chess piece behaviour and attributes
# Subclasses contain specialized behaviour for individual pieces (e.g., how they move)

# Base class ChessPiece which contains general chess piece behaviour
class ChessPiece
  attr_reader :color, :curr_position

  def initialize(color:, curr_position:)
    @color = color
    @curr_position = curr_position

    post_init
  end

  def post_init; end
end