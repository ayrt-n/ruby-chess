# frozen_string_literal: true

# Class containing Bishop play logic
class Bishop < ChessPiece
  def valid_moves(board, pos)
    valid_moves = []

    bishop_moves.each do |move|
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
    '♝'.colorize(color)
  end

  private

  def bishop_moves
    [diagonally].flatten
  end
end
