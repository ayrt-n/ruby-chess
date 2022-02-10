# frozen_string_literal: true

require './lib/chess_board'
require './lib/coordinates'

# Class containing game flow logic
class ChessGame
  include Coordinates

  attr_reader :board
  attr_accessor :current_player, :other_player

  def initialize(current_player = :white, other_player = :black, board = ChessBoard.new)
    @current_player = current_player
    @other_player = other_player
    @board = board
  end

  def game
    loop do
      player_turn
      next_player
    end
  end

  def player_turn
    loop do
      board.pretty_print
      piece = select_piece
      move = select_move(piece)

      next if move.nil?

      board.move(piece, move)
      break
    end
  end

  def checked?
    king_pos = board.king(current_player)
    enemy_moves = board.check_all_valid_moves(other_player)

    enemy_moves.include?(king_pos)
  end

  def select_move(piece)
    valid_moves = board.check_valid_moves(piece)
    selected = [piece] + valid_moves
    board.pretty_print(selected)

    loop do
      move = prompt_player_move
      return if move == ''

      if valid_coord?(move)
        move = chess_to_array_index(move)
        return move if valid_moves.include?(move)
      end

      puts 'Invalid selection - Please select a valid move'
    end
  end

  def select_piece
    loop do
      position = prompt_player_move

      if valid_coord?(position)
        position = chess_to_array_index(position)
        return position if board.color(position) == current_player
      end

      puts 'Invalid selection - Please select one of your pieces'
    end
  end

  def prompt_player_move
    loop do
      input = gets.chomp
      return input if valid_coord?(input) || input == ''

      puts 'Invalid selection - Please enter valid coordinate'
    end
  end

  def next_player
    tmp = current_player
    self.current_player = other_player
    self.other_player = tmp
  end
end

game = ChessGame.new
game.game