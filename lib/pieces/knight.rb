# frozen_string_literal: true

# Class containing knight play logic
class Knight < ChessPiece
  def valid_moves(board, pos)
    valid_moves = []

    knight_moves.each do |move|
      next_move = move(pos, move)
      valid_moves << next_move if move_valid?(board, next_move)
    end

    valid_moves
  end

  def to_s
    '♞'.colorize(color)
  end

  private

  def knight_moves
    jumps
  end
end
