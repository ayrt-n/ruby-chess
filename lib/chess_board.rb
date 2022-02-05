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
    board[ending] = board[starting]
    board[starting] = nil
  end

  def in_bounds?(position)
    position >= 0 && position < board.size
  end

  def empty?(position)
    board[position].nil?
  end

  def color(position)
    return if board.empty?(position)

    board[position].color
  end

  def pretty_print
    puts ''
    board.each_with_index do |sq, index|
      print " #{8 - (index / 8)} " if (index % 8).zero?
      pattern = (index / 8).even? ? %i[red light_black] : %i[light_black red]

      if sq.nil? 
        print '   '.colorize(:background => pattern[index % 2])
      else
        print " #{sq} ".colorize(:background => pattern[index % 2])
      end

      puts '' if ((index + 1) % 8).zero?
    end
    puts '    a  b  c  d  e  f  g  h '
  end

  private

  def new_board
    [create_chessmen(:black),
     create_pawns(:black),
     nil, nil, nil, nil, nil, nil, nil, nil,
     nil, nil, nil, nil, nil, nil, nil, nil,
     nil, nil, nil, nil, nil, nil, nil, nil,
     nil, nil, nil, nil, nil, nil, nil, nil,
     create_pawns(:white),
     create_chessmen(:white)].flatten
  end

  def create_chessmen(color)
    [Rook.new(color), Knight.new(color), Bishop.new(color), King.new(color), Queen.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)]
  end

  def create_pawns(color)
    Array.new(8) { Pawn.new(color) }
  end
end
