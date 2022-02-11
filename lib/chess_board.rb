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

  # Moves piece from starting position to ending positon
  def move(starting, ending)
    board[ending[0]][ending[1]] = board[starting[0]][starting[1]]
    board[starting[0]][starting[1]] = nil
  end

  # Checks whether a position is within boundaries of board
  # Returns true if inbounds, false otherwise
  def in_bounds?(position)
    position[0] >= 0 && position[0] < board.size &&
      position[1] >= 0 && position[1] < board[0].size
  end

  # Returns contents of board at given position [y, x]
  def at_index(position)
    board[position[0]][position[1]]
  end

  # Checks if a given spot is empty (i.e., nil)
  # Returns true if empty, false otherwise
  def empty?(position)
    at_index(position).nil?
  end

  # Returns the color/player at a given position [y, x]
  # If spot is empty, returns nil
  def color(position)
    return if empty?(position)

    at_index(position).color
  end

  # Returns array of potential moves a piece can make, given the current board
  # Moves based off of piece movement, does not take into account any other restrictions 
  # (i.e., whether move would result in check/checkmate)
  def return_potential_moves(position)
    return if empty?(position)

    at_index(position).valid_moves(self, position)
  end

  # Returns a hash of all { [piece_position]: [moves] } combinations for a given color/player
  def return_all_potential_moves(color)
    moves = {}
    board.each_with_index do |row, row_num|
      row.each_index do |col_num|
        position = [row_num, col_num]
        moves[position] = return_potential_moves(position) if color(position) == color
      end
    end

    moves
  end

  # Returns an array of all positions under attack by a given color/player
  def positions_under_attack_by(color)
    all_potential_moves = return_all_potential_moves(color)
    all_potential_moves.values.flatten(1)
  end

  # Returns the position of the King piece for a given color/player
  def king(color)
    board.each_with_index do |row, row_num|
      row.each_index do |col_num|
        position = [row_num, col_num]
        return position if at_index(position).instance_of?(King) && color(position) == color
      end
    end
  end

  # Prints contents of the board, can highlight specific squares if position provided
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

  # Creates default new board
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

  # Creates default row of chessmen of a given color
  def create_chessmen(color)
    [Rook.new(color), Knight.new(color), Bishop.new(color), Queen.new(color), King.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)]
  end

  # Creates default row of pawns of a given color
  def create_pawns(color)
    Array.new(8) { Pawn.new(color) }
  end

  # Creates row of nil spaces
  def create_nil_row
    [nil, nil, nil, nil, nil, nil, nil, nil]
  end
end
