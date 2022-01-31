# frozen_string_literal: true

# Collection of chess piece classes
# Base class ChessPiece contains general chess piece behaviour and attributes
# Subclasses contain specialized behaviour for individual pieces (e.g., how they move)

# Base class ChessPiece which contains general chess piece behaviour
class ChessPiece
  attr_reader :color, :curr_position

  def initialize(color:, curr_position:)
    @color = color
    @curr_position = curr_position

    post_init
  end

  def post_init; end

  def enemy_color
    color == 'W' ? 'B' : 'W'
  end
end

# Class containing pawn play logic
class Pawn < ChessPiece
  attr_reader :direction, :moved

  def post_init
    @direction = (color == 'W' ? -1 : 1)
    @moved = false
  end

  def valid_moves(board)
    valid_moves = []

    valid_moves << one_forward if board.empty?(one_forward)
    valid_moves << two_forward if board.empty?(one_forward) && board.empty?(two_forward) && !moved
    valid_moves << one_left_diagonal if pawn_takes?(board, one_left_diagonal)
    valid_moves << one_right_diagonal if pawn_takes?(board, one_right_diagonal)

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

  def pawn_takes?(board, position)
    board.color(position) == enemy_color && board.in_bounds?(position)
  end

  def one_forward_valid?(board)
    board.empty?(one_forward) && board.in_bounds?(one_forward)
  end

  def two_forward_valid?(board)
    board.empty?(one_forward) && board.empty(two_forward) && board.in_bounds?(two_forward) && !moved
  end
end

# Class containing knight play logic
class Knight < ChessPiece
  def valid_moves(board)
    valid_moves = []

    knight_moves.each do |move|
      valid_moves << move if move_valid?(board, move)
    end

    valid_moves
  end

  private

  def knight_moves
    [curr_position + 6,
     curr_position + 10,
     curr_position + 15,
     curr_position + 17,
     curr_position - 6,
     curr_position - 10,
     curr_position - 15,
     curr_position - 17]
  end

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) == enemy_color || board.empty?(move))
  end
end