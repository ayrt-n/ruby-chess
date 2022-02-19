# frozen_string_literal: true

require './lib/pieces/chess_piece'

# Class containing Rook play logic
class Rook < ChessPiece
  # Return array of valid moves based on piece movement (does not account for other rules of the game)
  def valid_moves(board, pos)
    valid_moves = []

    rook_moves.each do |move|
      next_move = move(pos, move)

      while move_valid?(board, next_move)
        valid_moves << next_move
        break if take?(board, next_move)

        next_move = move(next_move, move)
      end
    end

    valid_moves
  end

  # Makes to_s method pretty!
  def to_s
    '♜'.colorize(color)
  end

  private

  def rook_moves
    up_and_down + side_to_side
  end
end
