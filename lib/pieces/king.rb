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

    if valid_right_castle?(board, pos)
      right_move = move(move(pos, right), right)
      valid_castle_moves << right_move
    end

    if valid_left_castle?(board, pos)
      left_move = move(move(pos, left), left)
      valid_castle_moves << left_move
    end

    valid_castle_moves
  end

  def to_s
    '♚'.colorize(color)
  end

  private

  def valid_right_castle?(board, pos)
    3.times do
      next_move = move(pos, right)
      return false unless castle_move_valid?(board, next_move)

      next_move = move(next_move, right)
      return false unless castle_move_valid?(board, next_move)

      rook_pos = move(next_move, right)
      return false unless board.at_index(rook_pos).instance_of?(Rook) && board.at_index(rook_pos).not_moved?
    end
  end

  def valid_left_castle?(board, pos)
    4.times do
      next_move = move(pos, left)
      return false unless castle_move_valid?(board, next_move)

      next_move = move(next_move, left)
      return false unless castle_move_valid?(board, next_move)

      rook_pos = move(move(next_move, left), left)
      return false unless board.at_index(rook_pos).instance_of?(Rook) && board.at_index(rook_pos).not_moved?
    end
  end

  def castle_move_valid?(board, move)
    board.in_bounds?(move) && board.empty?(move) &&
      !board.under_attack_at?(move, color)
  end

  def king_moves
    up_and_down + side_to_side + diagonally
  end
end
