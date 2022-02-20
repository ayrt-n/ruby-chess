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
  attr_accessor :board, :en_passantable

  def initialize(board = new_board)
    @board = board
  end

  # Moves piece from starting position to ending positon
  def move(starting, ending)
    if castling?(starting, ending)
      castle(starting, ending)
    elsif en_passant_take?(starting, ending)
      en_passant(starting, ending)
    else
      move_piece(starting, ending)
    end

    post_move_routine(starting, ending)
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

  # Returns a hash of all valid { [piece_position]: [moves] } combinations for a given color/player
  def return_all_valid_moves(color)
    potential_moves = return_all_potential_moves(color)
    valid_moves = Hash.new([])

    potential_moves.each do |piece, moves|
      valid_moves[piece] = moves.reject { |move| invalid_move?(piece, move) }
      valid_moves[piece] += return_castle_moves(piece) if castleable_piece?(piece)
    end

    valid_moves
  end

  # Checks whether a given color/player is under attack at a certain position
  def under_attack_at?(position, color)
    villian_color = enemy_color(color)
    villian_moves = positions_under_attack_by(villian_color)

    villian_moves.include?(position)
  end

  # Returns true if given color/player king is under attack by enemy
  def checked?(color)
    villian_color = enemy_color(color)
    king_pos = king(color)
    villian_moves = positions_under_attack_by(villian_color)

    villian_moves.include?(king_pos)
  end

  def stalemate?(color)
    !checked?(color) && no_valid_moves?(color)
  end

  def checkmate?(color)
    checked?(color) && no_valid_moves?(color)
  end

  # Prints contents of the board, can highlight specific squares if position provided
  def pretty_print(highlight = [])
    puts ''
    puts '    a  b  c  d  e  f  g  h '
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
      print " #{8 - row_num} "
      puts ''
    end
    puts '    a  b  c  d  e  f  g  h '
    puts ''
  end

  private

  # Move piece on the board, starting position becomes nil (empty)
  def move_piece(starting, ending)
    board[ending[0]][ending[1]] = board[starting[0]][starting[1]]
    board[starting[0]][starting[1]] = nil
  end

  # Check if move is an en passant take, return true/false
  def en_passant_take?(starting, ending)
    return false unless at_index(starting).instance_of?(Pawn)

    is_a_take = (starting[1] - ending[1]).abs == 1

    is_a_take && empty?(ending)
  end

  # Make en passant take moves
  def en_passant(starting, ending)
    move_piece(starting, ending)

    board[en_passantable[0]][en_passantable[1]] = nil
  end

  # Check if the move made puts piece vulnerable to en passant
  def en_passantable_move?(starting, ending)
    return false unless at_index(ending).instance_of?(Pawn)

    (starting[0] - ending[0]).abs > 1
  end

  # Reset instance variable of en passantable pieces
  def reset_en_pass_pawn
    @en_passantable = []
  end

  # Add piece to instance variable of en passantable pieces
  def queue_en_pass_pawn(position)
    @en_passantable = position
  end

  # Check if move is castling based on piece and distance moved
  def castling?(starting, ending)
    return false unless at_index(starting).instance_of?(King)

    (starting[1] - ending[1]).abs > 1
  end

  # Makes castle moves
  def castle(starting, ending)
    move_piece(starting, ending)

    if (starting[1] - ending[1]).negative?
      move_piece([starting[0], 7], [starting[0], 5])

      board[starting[0]][5].moved = true
    else
      move_piece([starting[0], 0], [starting[0], 3])

      board[starting[0]][3].moved = true
    end

    at_index(ending).moved = true
  end

  def return_castle_moves(position)
    return if empty?(position)

    at_index(position).castle_moves(self, position)
  end

  def castleable_piece?(position)
    at_index(position).instance_of?(King)
  end

  # Runs through number of checks and updates to game state (moved, pawn promotion, en passant)
  def post_move_routine(starting, ending)
    at_index(ending).moved = true
    promote(ending) if promotion?(ending)
    reset_en_pass_pawn
    queue_en_pass_pawn(ending) if en_passantable_move?(starting, ending)
  end

  # Replace the piece at a given position with a Queen
  def promote(position)
    piece_color = color(position)
    promotion_piece = prompt_promotion_piece
    board[position[0]][position[1]] = promotion_piece.new(piece_color)
  end

  # Check if piece at given position qualifies for a promotion
  def promotion?(position)
    return if empty?(position)

    at_index(position).promotion?(self, position)
  end

  # Prompt user for input as to what they want piece to be promoted to
  def prompt_promotion_piece
    loop do
      print 'Pawn promotion! Upgrade to a Queen, Rook, Bishop, or Knight?: '
      input = gets.chomp.capitalize!
      return Object.const_get(input) if %w[Queen Rook Bishop Knight].include?(input)

      puts 'Invalid input - Please select Queen, Rook, Bishop, or Knight'
    end
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

  # Returns true if given color/player has no valid moves
  def no_valid_moves?(color)
    valid_moves = return_all_valid_moves(color)
    valid_moves.values.flatten.empty?
  end

  # Returns an array of all positions under attack by a given color/player
  def positions_under_attack_by(color)
    all_potential_moves = return_all_potential_moves(color)
    all_potential_moves.values.flatten(1)
  end

  # Checks whether move puts player making the move into check, making it invalid
  def invalid_move?(starting, ending)
    tmp = board.dup.map(&:dup)

    move_piece(starting, ending)
    self_check = checked?(color(ending))

    @board = tmp
    self_check
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

  # Returns the enemy color given a certain player color
  def enemy_color(color)
    color == :white ? :black : :white
  end

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
