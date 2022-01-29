# frozen_string_literal: true

# Collection of chess piece classes
# Each class contains logic which defines how pieces are able to move

# Class containing pawn play logic
class Pawn
  attr_reader :color

  def initialize(color:)
    @color = color
  end
end