# frozen_string_literal: true

require './lib/pieces/chess_piece'

# Class containing pawn play logic
class Pawn < ChessPiece
  attr_reader :direction
  attr_accessor :moved

  # Return array of valid moves based on piece movement (does not account for other rules of the game)
  def valid_moves(board, pos)
    valid_moves = []

    valid_moves << one_forward(pos) if move_valid?(board, one_forward(pos))
    valid_moves << two_forward(pos) if move_valid?(board, one_forward(pos)) && move_valid?(board, two_forward(pos)) && not_moved?
    valid_moves << left_diagonal(pos) if take?(board, left_diagonal(pos)) || left_en_passant?(board, pos)
    valid_moves << right_diagonal(pos) if take?(board, right_diagonal(pos)) || right_en_passant?(board, pos)

    valid_moves
  end

  # Makes to_s method pretty!
  def to_s
    '♟︎'.colorize(color)
  end

  # Check if pawn qualified for promotion, return bool
  def promotion?(board, pos)
    !board.in_bounds?(one_forward(pos))
  end

  private

  def left_en_passant?(board, pos)
    direct_left = move(pos, left)
    board.en_passantable == direct_left
  end

  def right_en_passant?(board, pos)
    direct_left = move(pos, right)
    board.en_passantable == direct_left
  end

  def forward
    if color == :white
      up
    else
      down
    end
  end

  def one_forward(pos)
    move(pos, forward)
  end

  def two_forward(pos)
    move(one_forward(pos), forward)
  end

  def left_diagonal(pos)
    if color == :white
      move(pos, up_left)
    else
      move(pos, down_left)
    end
  end

  def right_diagonal(pos)
    if color == :white
      move(pos, up_right)
    else
      move(pos, down_right)
    end
  end

  def move_valid?(board, move)
    board.in_bounds?(move) && board.empty?(move)
  end
end
