# frozen_string_literal: true

# Class containing King play logic
class King < ChessPiece
  def valid_moves(board)
    valid_moves = []

    king_moves.each do |move|
      next_move = curr_position + move
      valid_moves << next_move if move_valid?(board, next_move)
    end

    valid_moves
  end

  private

  def king_moves
    [up_and_down, side_to_side, diagonally].flatten
  end

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) == enemy_color || board.empty?(move))
  end
end
