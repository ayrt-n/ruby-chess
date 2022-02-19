# frozen_string_literal: true

require './lib/pieces/chess_piece'

# Class containing knight play logic
class Knight < ChessPiece
  # Return array of valid moves based on piece movement (does not account for other rules of the game)
  def valid_moves(board, pos)
    valid_moves = []

    knight_moves.each do |move|
      next_move = move(pos, move)
      valid_moves << next_move if move_valid?(board, next_move)
    end

    valid_moves
  end

  # Makes to_s method pretty!
  def to_s
    '♞'.colorize(color)
  end

  private

  def knight_moves
    jumps
  end
end
