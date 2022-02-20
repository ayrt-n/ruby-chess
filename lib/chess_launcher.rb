# frozen_string_literal: true

require './lib/chess_game'
require 'yaml'

# Class to launch or load game of chess
class ChessLauncher
  # Main launching method - prompts user for game type and launches game
  def play_game
    welcome_message
    game_type = prompt_player_input([1, 2])

    game = if game_type == 1
             launch_new_game
           else
             launch_saved_game
           end

    game.play
  end

  private

  # Launch new ChessGame
  def launch_new_game
    ChessGame.new
  end

  # Makes calls to displays saved games (if available), prompt game selection
  # and launch the saved game
  def launch_saved_game
    savestates = Dir.glob("savestates/*.{yaml, YAML}")
    if savestates.empty?
      puts "\nNo saved games found - launching new game"
      launch_new_game
    else
      puts "\nSelect one of the saved games to play:"
      print_saved_games(savestates)
      saved_game = select_saved_game(savestates)
      load_game(saved_game)
    end
  end

  # Prompt player to select saved game
  def select_saved_game(savestates)
    acceptable_values = [*1..savestates.size]
    file_idx = prompt_player_input(acceptable_values) - 1
    File.open(savestates[file_idx], 'r').read
  end

  # Print out saved games with human-count adjusted indices
  def print_saved_games(savestates)
    savestates.each_with_index do |file, idx|
      puts "[#{idx + 1}] #{File.basename(file)}"
    end
  end

  # Load game given YAML string
  def load_game(string)
    YAML.load(string)
  end

  # Prompt player for input, specifying acceptable (integer) values
  def prompt_player_input(acceptable_values)
    loop do
      input = gets.chomp.to_i
      return input if acceptable_values.include?(input)

      puts 'Invalid selection - Please select one of the listed options'
    end
  end

  # Simple welcome message with game options
  def welcome_message
    puts <<~HEREDOC

      Welcome to Ruby Chess! To start a game, select one of the following...

      [1] Play new game
      [2] Load saved game

    HEREDOC
  end
end
