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

  def game
    loop do
      valid_moves = all_valid_moves(current_player)
      break if checkmate?(valid_moves)

      puts 'Check! Your king is under attack, protect him!' if checked?(current_player)

      break if player_turn(valid_moves) == 'sq'
      switch_current_player
    end
    print_board
    puts "Checkmate! #{not_current_player.capitalize} wins!"
  end

  def player_turn(valid_moves)
    loop do
      print_board
      piece = select_piece
      if piece == 'sq'
        save_game
        return 'sq'
      end
      puts 'made it here'
      print_board(piece, valid_moves[piece])
      move = select_move(valid_moves[piece])

      next if move.nil?

      move_piece(piece, move)
      break
    end
  end

  def checkmate?(player_moves)
    player_moves.values.flatten.empty?
  end

  def all_valid_moves(player)
    potential_moves = all_potential_moves(player)
    valid_moves = Hash.new([])

    potential_moves.each do |piece, moves|
      valid_moves[piece] = moves.reject { |move| move_self_check?(piece, move) }
    end

    valid_moves
  end

  def all_potential_moves(player)
    board.return_all_potential_moves(player)
  end

  def move_self_check?(piece, move)
    tmp = board.board.dup.map(&:dup)
    board.move(piece, move)
    self_check = checked?(current_player)
    board.board = tmp
    self_check
  end

  def checked?(player)
    king_pos = board.king(player)
    enemy = other_player(player)
    enemy_moves = board.positions_under_attack_by(enemy)

    enemy_moves.include?(king_pos)
  end

  def select_move(valid_moves)
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
      print "#{current_player.capitalize} select piece (or type 'sq' to save and quit): "
      position = gets.chomp

      if valid_coord?(position)
        position = chess_to_array_index(position)
        return position if board.color(position) == current_player
      elsif position == 'sq'
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

  def other_player(player)
    player == current_player ? not_current_player : current_player
  end

  def save_game
    savestate = Savestate.new('savestates')
    savestate.create_savestate(self)
  end
end

# game = ChessGame.new
# game.game