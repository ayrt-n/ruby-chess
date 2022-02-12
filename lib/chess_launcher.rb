# frozen_string_literal: true

require './lib/savestate'
require './lib/chess_game'
require 'yaml'

# Class to launch or load game of chess
class ChessLauncher
  def play_game
    welcome_message
    game_type = prompt_player_input([1, 2])

    game = if game_type == 1
             launch_new_game
           else
             select_saved_game
           end

           game.game
  end

  private

  def launch_new_game
    ChessGame.new
  end

  def select_saved_game
    puts "\nSelect one of the saved games to play:"
    savestates = Dir.glob("savestates/*.{yaml, YAML}")
    print_saved_games(savestates)
    file_idx = prompt_player_input([*1..savestates.size])
    file = File.open(savestates[file_idx], 'r').read
    p file
    load_game(file)
  end

  def print_saved_games(savestates)
    savestates.each_with_index do |file, idx|
      puts "[#{idx + 1}] #{File.basename(file)}"
    end
  end

  def load_game(string)
    YAML.load(string)
  end
  
  def prompt_player_input(acceptable_values)
    loop do
      input = gets.chomp
      return input.to_i if acceptable_values.include?(input.to_i)

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
