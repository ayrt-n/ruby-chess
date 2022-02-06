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

  def prompt_player_move
    loop do
      input = gets.chomp
      return input if valid_coord?(input)

      puts 'Invalid move - Please enter valid coordinate'
    end
  end
end