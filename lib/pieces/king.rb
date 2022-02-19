# frozen_string_literal: true

require './lib/pieces/chess_piece'

# Class containing King play logic
class King < ChessPiece
  # Return array of valid moves based on piece movement (does not account for other rules of the game)
  def valid_moves(board, pos)
    valid_moves = []

    king_moves.each do |move|
      next_move = move(pos, move)
      valid_moves << next_move if move_valid?(board, next_move)
    end

    valid_moves
  end

  # Returns array of valid castle moves based on rules of castling
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

  # Makes to_s method pretty!
  def to_s
    '♚'.colorize(color)
  end

  private

  def valid_right_castle?(board, pos)
    one_right = move(pos, right)
    two_right = move(one_right, right)
    return false unless castle_move_valid?(board, one_right) && castle_move_valid?(board, two_right)

    rook_pos = move(two_right, right)
    castleable_rook?(board, rook_pos)
  end

  def valid_left_castle?(board, pos)
    one_left = move(pos, left)
    two_left = move(one_left, left)
    return false unless castle_move_valid?(board, one_left) && castle_move_valid?(board, two_left)

    rook_pos = move(move(two_left, left), left)
    castleable_rook?(board, rook_pos)
  end

  def castle_move_valid?(board, move)
    board.in_bounds?(move) && board.empty?(move) &&
      !board.under_attack_at?(move, color)
  end

  def castleable_rook?(board, pos)
    board.at_index(pos).instance_of?(Rook) && board.at_index(pos).not_moved? && board.color(pos) == color
  end

  def king_moves
    up_and_down + side_to_side + diagonally
  end
end
