# frozen_string_literal: true

# Class containing pawn play logic
class Pawn < ChessPiece
  attr_reader :direction
  attr_accessor :moved

  def valid_moves(board, pos)
    valid_moves = []

    valid_moves << one_forward(pos) if move_valid?(board, one_forward(pos))
    valid_moves << two_forward(pos) if move_valid?(board, one_forward(pos)) && move_valid?(board, two_forward(pos)) && not_moved?
    valid_moves << left_diagonal(pos) if take?(board, left_diagonal(pos))
    valid_moves << right_diagonal(pos) if take?(board, right_diagonal(pos))

    valid_moves
  end

  def to_s
    '♟︎'.colorize(color)
  end

  def promotion?(board, pos)
    !board.in_bounds?(one_forward(pos))
  end

  private

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
