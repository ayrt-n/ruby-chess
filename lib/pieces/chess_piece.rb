# frozen_string_literal: true

require './lib/pieces/movement'
require 'colorize'

# Base class ChessPiece contains general chess piece behaviour and attributes
# Subclasses contain specialized behaviour for individual pieces (i.e., how they move)

# Base class ChessPiece which contains general chess piece behaviour
class ChessPiece
  include Movement

  attr_reader :color
  attr_accessor :moved

  def initialize(color, moved: false)
    @color = color
    @moved = moved
  end

  def promotion?(_, _)
    false
  end

  def not_moved?
    !moved
  end

  private

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) != color || board.empty?(move))
  end

  def take?(board, move)
    board.in_bounds?(move) && board.color(move) != color && !board.empty?(move)
  end

  def move(current_position, move)
    new_position = []
    current_position.each_index { |i| new_position[i] = current_position[i] + move[i] }
    new_position
  end
end
