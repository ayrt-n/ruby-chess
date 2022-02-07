# frozen_string_literal: true

# Class containing King play logic
class King < ChessPiece
  def valid_moves(board, pos)
    valid_moves = []

    king_moves.each do |move|
      next_move = move(pos, move)
      valid_moves << next_move if move_valid?(board, next_move)
    end

    valid_moves
  end

  def to_s
    '♛'.colorize(color)
  end

  private

  def king_moves
    up_and_down + side_to_side + diagonally
  end
end
