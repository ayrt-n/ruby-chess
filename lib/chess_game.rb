# frozen_string_literal: true

require './lib/chess_board'
require './lib/coordinates'

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
      player_turn
      switch_current_player
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
    board.check_all_valid_moves(player)
  end

  def move_self_check?(piece, move)
    tmp = board.board.dup.map(&:dup)
    board.fake_move(piece, move)
    self_check = checked?(current_player)
    board.board = tmp
    self_check
  end

  def checked?(player)
    king_pos = board.king(player)
    enemy = other_player(player)
    enemy_moves = board.check_all_valid_moves(enemy).values.flatten(1)

    enemy_moves.include?(king_pos)
  end

  def select_move(piece)
    valid_moves = valid_moves(piece)
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

  def switch_current_player
    tmp = current_player
    self.current_player = not_current_player
    self.not_current_player = tmp
  end

  def other_player(player)
    player == current_player ? not_current_player : current_player
  end
end

game = ChessGame.new
game.game