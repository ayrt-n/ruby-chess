# frozen_string_literal: true

require './lib/chess_board'
require './lib/coordinates'
require './lib/savestate'

# Class containing game flow logic
class ChessGame
  include Coordinates

  attr_accessor :current_player, :not_current_player, :board

  def initialize(current_player = :white, not_current_player = :black, board = ChessBoard.new)
    @current_player = current_player
    @not_current_player = not_current_player
    @board = board
  end

  def play
    outcome_of_game = game
    case outcome_of_game
    when :checkmate
      puts "Checkmate! #{not_current_player.capitalize} wins!"
    when :sq
      save_game
      puts 'Game saved!'
    else
      puts "#{current_player.capitalize} has had enough! #{not_current_player.capitalize} wins!"
    end
  end

  def game
    loop do
      return :checkmate if board.checkmate?(current_player)

      valid_moves = board.return_all_valid_moves(current_player)
      puts "Check! The #{current_player} king is under attack, protect him!" if board.checked?(current_player)

      player_move = player_turn(valid_moves)
      return player_move.to_sym if %w[sq surrender].include?(player_move)

      switch_current_player
    end
  end

  def player_turn(valid_moves)
    loop do
      print_board
      piece = select_piece
      return piece if piece == 'sq' || piece == 'surrender'

      print_board(piece, valid_moves[piece])
      move = select_move(valid_moves[piece])

      next if move.nil?

      board.move(piece, move)
      return piece
    end
  end

  def select_move(valid_moves)
    loop do
      print "#{current_player.capitalize} select move (or hit <ENTER> to cancel): "
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
      print "#{current_player.capitalize} select piece (or type 'sq' to save and quit or 'surrender' to surrender): "
      position = gets.chomp

      if valid_coord?(position)
        position = chess_to_array_index(position)
        return position if board.color(position) == current_player
      elsif position == 'sq' || position == 'surrender'
        return position
      end

      puts 'Invalid selection - Please select one of your pieces'
    end
  end

  def move_piece(piece, move)
    board.move(piece, move)
    board.at_index(move).moved = true
  end

  def print_board(piece = [], moves = [])
    highlight = [piece] + moves
    board.pretty_print(highlight)
  end

  def prompt_player_move
    loop do
      input = gets.chomp
      return input if valid_coord?(input) || input == ''

      puts 'Invalid selection - Please enter valid coordinate'
    end
  end

  def switch_current_player
    tmp = current_player
    self.current_player = not_current_player
    self.not_current_player = tmp
  end

  def save_game
    savestate = Savestate.new('savestates')
    savestate.create_savestate(self)
  end
end

# game = ChessGame.new
# game.game