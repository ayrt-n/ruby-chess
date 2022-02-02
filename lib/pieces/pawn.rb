# frozen_string_literal: true

# Class containing pawn play logic
class Pawn < ChessPiece
  attr_reader :direction, :moved

  def post_init
    @direction = (color == 'W' ? -1 : 1)
    @moved = false
  end

  def valid_moves(board)
    valid_moves = []

    valid_moves << one_forward if one_forward_valid?(board)
    valid_moves << two_forward if two_forward_valid?(board)
    valid_moves << one_left_diagonal if take?(board, one_left_diagonal)
    valid_moves << one_right_diagonal if take?(board, one_right_diagonal)

    valid_moves
  end

  private

  def one_forward
    curr_position + (8 * direction)
  end

  def two_forward
    one_forward + (8 * direction)
  end

  def one_left_diagonal
    curr_position + (9 * direction)
  end

  def one_right_diagonal
    curr_position + (7 * direction)
  end

  def one_forward_valid?(board)
    board.empty?(one_forward) && board.in_bounds?(one_forward)
  end

  def two_forward_valid?(board)
    board.empty?(one_forward) && board.empty?(two_forward) && board.in_bounds?(two_forward) && !moved
  end
end
