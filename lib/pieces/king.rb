# frozen_string_literal: true

require './lib/pieces/chess_piece'

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

  def castle_moves(board, pos)
    valid_castle_moves = []

    side_to_side.each do |move|
      next_move = move(pos, move)
      next unless castle_move_valid?(board, next_move)
      next_move = move(next_move, move)
      castle_moves << next_move if castle_move_valid?(board, next_move)
    end

    valid_castle_moves
  end

  def to_s
    '♚'.colorize(color)
  end

  private

  def castle_move_valid?(board, move)
    board.in_bounds?(move) && board.empty?(move) &&
      !board.under_attack_at?(move, color)
  end

  def king_moves
    up_and_down + side_to_side + diagonally
  end
end
