# frozen_string_literal: true

require './lib/pieces/movement'
require 'colorize'

# Base class ChessPiece contains general chess piece behaviour and attributes
# Subclasses contain specialized behaviour for individual pieces (i.e., how they move)

# Base class ChessPiece which contains general chess piece behaviour
class ChessPiece
  include Movement

  attr_reader :color

  def initialize(color)
    @color = color

    post_init
  end

  def post_init; end

  private

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) != color || board.empty?(move))
  end

  def take?(board, move)
    board.color(move) != color && !board.empty?(move)
  end
end
