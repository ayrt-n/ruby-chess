# frozen_string_literal: true

require './lib/chess_game'

describe ChessGame do
  describe '#game' do
    let(:board) { double('board') }
    let(:game) { ChessGame.new(board: board) }

    before(:each) do
      allow(board).to receive(:pretty_print)
      allow(board).to receive(:checked?).and_return(false)
    end

    it 'breaks out of loop when checkmate' do
      allow(board).to receive(:checkmate?).and_return(true)
      outcome_of_game = game.send(:game)
      expect(outcome_of_game).to eql(:checkmate)
    end

    it 'breaks out of loop when save and quit' do
      allow(board).to receive(:checkmate?).and_return(false)
      allow(board).to receive(:return_all_valid_moves)
      allow(game).to receive(:player_turn).and_return('sq')

      outcome_of_game = game.send(:game)
      expect(outcome_of_game).to eql(:sq)
    end

    it 'breaks out of loop when surrender' do
      allow(board).to receive(:checkmate?).and_return(false)
      allow(board).to receive(:return_all_valid_moves)
      allow(game).to receive(:player_turn).and_return('surrender')

      outcome_of_game = game.send(:game)
      expect(outcome_of_game).to eql(:surrender)
    end
  end
end
