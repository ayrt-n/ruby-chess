# frozen_string_literal: true

require './lib/movement'

# Collection of chess piece classes
# Base class ChessPiece contains general chess piece behaviour and attributes
# Subclasses contain specialized behaviour for individual pieces (e.g., how they move)

# Base class ChessPiece which contains general chess piece behaviour
class ChessPiece
  include Moveset

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

    valid_moves << one_forward if one_forward_valid?(board)
    valid_moves << two_forward if two_forward_valid?(board)
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
    board.empty?(one_forward) && board.empty?(two_forward) && board.in_bounds?(two_forward) && !moved
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

# Class containing Rook play logic
class Rook < ChessPiece
  def valid_moves(board)
    valid_moves = []

    rook_moves.each do |move|
      next_move = curr_position + move

      while move_valid?(board, next_move)
        valid_moves << next_move
        break if take?(board, next_move)

        next_move += move
      end
    end

    valid_moves
  end

  private

  def rook_moves
    [up_and_down, side_to_side].flatten
  end

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) == enemy_color || board.empty?(move))
  end

  def take?(board, move)
    board.color(move) == enemy_color
  end
end

# Class containing Bishop play logic
class Bishop < ChessPiece
  def valid_moves(board)
    valid_moves = []

    bishop_moves.each do |move|
      next_move = curr_position + move

      while move_valid?(board, next_move)
        valid_moves << next_move
        break if take?(board, next_move)

        next_move += move
      end
    end

    valid_moves
  end

  private

  def bishop_moves
    [diagonally].flatten
  end

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) == enemy_color || board.empty?(move))
  end

  def take?(board, move)
    board.color(move) == enemy_color
  end
end

# Class containing Queen play logic
class Queen < ChessPiece
  def valid_moves(board)
    valid_moves = []

    queen_moves.each do |move|
      next_move = curr_position + move

      while move_valid?(board, next_move)
        valid_moves << next_move
        break if take?(board, next_move)

        next_move += move
      end
    end

    valid_moves
  end

  private

  def queen_moves
    [up_and_down, side_to_side, diagonally].flatten
  end

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) == enemy_color || board.empty?(move))
  end

  def take?(board, move)
    board.color(move) == enemy_color
  end
end

# Class containing King play logic
class King < ChessPiece
  def valid_moves(board)
    valid_moves = []

    king_moves.each do |move|
      next_move = curr_position + move
      valid_moves << next_move if move_valid?(board, next_move)
    end

    valid_moves
  end

  private

  def king_moves
    [up_and_down, side_to_side, diagonally].flatten
  end

  def move_valid?(board, move)
    board.in_bounds?(move) && (board.color(move) == enemy_color || board.empty?(move))
  end
end