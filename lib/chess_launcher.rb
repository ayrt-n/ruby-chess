# frozen_string_literal: true

<<<<<<< HEAD
require './lib/savestate'
require './lib/chess_game'

# Class to launch or load game of chess
class ChessLauncher
  def play_game
    welcome_message
    game_type = prompt_player_input(%w[1 2])

    game = if game_type == '1'
             launch_new_game
    end
  end

  private

  def launch_new_game
    ChessGame.new
  end
  
  def prompt_player_input(acceptable_values)
    loop do
      input = gets.chomp
      return input if acceptable_values.include?(input)

      puts 'Invalid selection - Please select one of the listed options'
    end
  end

  def welcome_message
    puts <<~HEREDOC

      Welcome to Ruby Chess! To start a game, select one of the following...

      [1] Play new game
      [2] Load saved game

    HEREDOC
  end
end

ChessLauncher.new.play_game
=======
require './lib/chess_game'

# Controller for starting/loading/replaying games of chess
class ChessLauncher

end
>>>>>>> game_board_functionality
