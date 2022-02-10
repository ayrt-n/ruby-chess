# frozen_string_literal: true

require 'colorize'
require './lib/pieces/chess_piece'
require './lib/pieces/pawn'
require './lib/pieces/rook'
require './lib/pieces/bishop'
require './lib/pieces/knight'
require './lib/pieces/queen'
require './lib/pieces/king'

# Class representation of chess board
# Keeps track of and updates the position of chess pieces throughout the game
class ChessBoard
  attr_accessor :board

  def initialize(board = new_board)
    @board = board
  end

  def move(starting, ending)
    board[ending[0]][ending[1]] = board[starting[0]][starting[1]]
    board[starting[0]][starting[1]] = nil

    at_index(ending).moved = true
  end

  def in_bounds?(position)
    position[0] >= 0 && position[0] < board.size &&
      position[1] >= 0 && position[1] < board[0].size
  end

  def at_index(position)
    board[position[0]][position[1]]
  end

  def empty?(position)
    at_index(position).nil?
  end

  def color(position)
    return if empty?(position)

    at_index(position).color
  end

  def check_valid_moves(position)
    return if empty?(position)

    at_index(position).valid_moves(self, position)
  end

  def check_all_valid_moves(color)
    moves = []
    board.each_with_index do |row, row_num|
      row.each_index do |col_num|
        position = [row_num, col_num]
        moves += check_valid_moves(position) if color(position) == color
      end
    end

    moves
  end

  def king(color)
    board.each_with_index do |row, row_num|
      row.each_index do |col_num|
        position = [row_num, col_num]
        return position if at_index(position).instance_of?(King) && color(position) == color
      end
    end
  end

  def pretty_print(highlight = [])
    puts ''
    board.each_with_index do |row, row_num|
      print " #{8 - row_num} "

      row.each_with_index do |sq, col_num|
        pattern = if highlight.include?([row_num, col_num])
                    %i[light_yellow light_yellow]
                  else
                    (row_num).even? ? %i[red light_black] : %i[light_black red]
                  end

        if sq.nil?
          print '   '.colorize(:background => pattern[col_num % 2])
        else
          print " #{sq} ".colorize(:background => pattern[col_num % 2])
        end
      end
      puts ''
    end
    puts '    a  b  c  d  e  f  g  h '
  end

  private

  def new_board
    [create_chessmen(:black),
     create_pawns(:black),
     create_nil_row,
     create_nil_row,
     create_nil_row,
     create_nil_row,
     create_pawns(:white),
     create_chessmen(:white)]
  end

  def create_chessmen(color)
    [Rook.new(color), Knight.new(color), Bishop.new(color), King.new(color), Queen.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)]
  end

  def create_pawns(color)
    Array.new(8) { Pawn.new(color) }
  end

  def create_nil_row
    [nil, nil, nil, nil, nil, nil, nil, nil]
  end
end
