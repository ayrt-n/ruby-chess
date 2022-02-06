# frozen_string_literal: true

require './lib/chess_board'
require './lib/coordinates'

# Class containing game flow logic
class ChessGame
  include Coordinates 

  def initialize(p1, p2, board = ChessBoard.new)
    @current_player = p1
    @other_player = p2
    @board = board
  end
end