# frozen_string_literal: true

require './lib/pieces/movement'

# Base class ChessPiece contains general chess piece behaviour and attributes
# Subclasses contain specialized behaviour for individual pieces (i.e., how they move)

# Base class ChessPiece which contains general chess piece behaviour
class ChessPiece
  include Movement

  attr_reader :color, :curr_position

  def initialize(color:, curr_position:)
    @color = color
    @curr_position = curr_position

    post_init
  end

  def post_init; end

  private

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) != color || board.empty?(move))
  end

  def take?(board, move)
    board.color(move) != color
  end
end
