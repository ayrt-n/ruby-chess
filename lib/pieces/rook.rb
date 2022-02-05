# frozen_string_literal: true

# Class containing Rook play logic
class Rook < ChessPiece
  def valid_moves(board, pos)
    valid_moves = []

    rook_moves.each do |move|
      next_move = pos + move

      while move_valid?(board, next_move)
        valid_moves << next_move
        break if take?(board, next_move)

        next_move += move
      end
    end

    valid_moves
  end

  def to_s
    '♜'.colorize(color)
  end

  private

  def rook_moves
    [up_and_down, side_to_side].flatten
  end
end
