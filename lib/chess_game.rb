# frozen_string_literal: true

require './lib/chess_board'
require './lib/coordinates'

# Class containing game flow logic
class ChessGame
  include Coordinates 

  def initialize(current_player = :white, board = ChessBoard.new)
    @current_player = current_player
    @board = board
  end

  def select_move(piece)
    valid_moves = board.board[piece].valid_moves

    loop do
      move = prompt_player_move
      return move if valid_moves.include?(move)

      puts 'Invalid move - Please select a valid move'
    end
  end

  def select_piece
    loop do
      position = chess_to_array_index(prompt_player_move)
      return position if board.color(position) == current_player

      puts 'Invalid selection - Please select one of your pieces'
    end
  end

  def prompt_player_move
    loop do
      input = gets.chomp
      return input if valid_coord?(input)

      puts 'Invalid move - Please enter valid coordinate'
    end
  end
end