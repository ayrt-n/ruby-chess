# frozen_string_literal: true

# Class containing pawn play logic
class Pawn < ChessPiece
  attr_reader :direction
  attr_accessor :moved

  def post_init
    @direction = (color == 'W' ? 1 : -1)
    @moved = false
  end

  def valid_moves(board)
    valid_moves = []

    valid_moves << one_forward if move_valid?(board, one_forward)
    valid_moves << two_forward if move_valid?(board, one_forward) && move_valid?(board, two_forward) && not_moved?
    valid_moves << left_diagonal if take?(board, left_diagonal)
    valid_moves << right_diagonal if take?(board, right_diagonal)

    valid_moves
  end
  
  def to_s
    '♟︎'
  end

  private

  def one_forward
    curr_position + (up * direction)
  end

  def two_forward
    curr_position + (up * direction * 2)
  end

  def left_diagonal
    curr_position + (up_left * direction)
  end

  def right_diagonal
    curr_position + (up_right * direction)
  end

  def move_valid?(board, move)
    board.empty?(move) && board.in_bounds?(move)
  end

  def not_moved?
    !moved
  end
end
