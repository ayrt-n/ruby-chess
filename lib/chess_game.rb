# frozen_string_literal: true

require './lib/chess_board'
require './lib/coordinates'
require './lib/savestate'

# Class containing game flow logic
class ChessGame
  include Coordinates

  attr_accessor :current_player, :not_current_player, :board

  def initialize(current_player: :white, not_current_player: :black, board: ChessBoard.new)
    @current_player = current_player
    @not_current_player = not_current_player
    @board = board
  end

  # Launch full game of chess, outcome_of_game returned as symbol and entered into
  # control flow to output ending message
  def play
    outcome_of_game = game
    print_board

    case outcome_of_game
    when :checkmate
      puts "Checkmate! #{not_current_player.capitalize} wins!"
    when :stalemate
      puts 'Stalemate! There are no winners.'
    when :sq
      save_game
    else
      puts "#{current_player.capitalize} has had enough! #{not_current_player.capitalize} wins!"
    end
  end

  private

  # Full game loop, loops through player turns and switches players after turn over
  # When game is over, returns symbol based on how the game was terminated (e.g., :checkmate)
  def game
    loop do
      return :checkmate if checkmate?(current_player)
      return :stalemate if stalemate?(current_player)

      valid_moves = player_valid_moves(current_player)
      puts "Check! The #{current_player} king is under attack, protect him!" if checked?(current_player)

      player_move = player_turn(valid_moves)
      return player_move.to_sym if %w[sq surrender].include?(player_move)

      switch_current_player
    end
  end

  # A single player turn loop, including piece selection and move selection
  def player_turn(valid_moves)
    loop do
      print_board
      piece = select_piece
      return piece if %w[sq surrender].include?(piece)

      print_board(piece, valid_moves[piece])
      move = select_move(valid_moves[piece])

      next if move.nil?

      board.move(piece, move)
      return piece
    end
  end

  # Prompts user for input on move selection, only allows player to select valid moves
  def select_move(valid_moves)
    loop do
      print "#{current_player.capitalize} select move (or hit <ENTER> to cancel): "
      move = gets.chomp
      return if move == ''

      if valid_coord?(move)
        move = chess_to_array_index(move)
        return move if valid_moves.include?(move)
      end

      puts 'Invalid selection - Please select a valid move'
    end
  end

  # Prompts user for input on piece selection, only allows player to select valid pieces
  # Alternatively, player may save and quit or surrender from piece selection option
  def select_piece
    loop do
      print "#{current_player.capitalize} select piece (or type 'sq' to save and quit or 'surrender' to surrender): "
      position = gets.chomp

      if valid_coord?(position)
        position = chess_to_array_index(position)
        return position if board.color(position) == current_player
      elsif %w[sq surrender].include?(position)
        return position
      end

      puts 'Invalid selection - Please select one of your pieces'
    end
  end

  # Encapsulates call to ChessBoard#pretty_print
  def print_board(piece = [], moves = [])
    highlight = [piece] + moves
    board.pretty_print(highlight)
  end

  # Encapsulates call to ChessBoard#checkmate?
  def checkmate?(player)
    board.checkmate?(player)
  end

  # Encapsulates call to ChessBoard#checkmate?
  def stalemate?(player)
    board.stalemate?(player)
  end

  # Encapsulates call to ChessBoard#checked?
  def checked?(player)
    board.checked?(player)
  end

  # Encapsulates call to ChessBoard#return_all_valid_moves
  def player_valid_moves(player)
    board.return_all_valid_moves(player)
  end

  # Switch the current player
  def switch_current_player
    tmp = current_player
    self.current_player = not_current_player
    self.not_current_player = tmp
  end

  # Create new instance of Savestate and save (serialize) current game state
  def save_game
    savestate = Savestate.new('savestates')
    savestate.create_savestate(self)
    puts 'Game saved!'
  end
end
