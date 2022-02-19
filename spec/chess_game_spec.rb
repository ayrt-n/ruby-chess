# frozen_string_literal: true

require './lib/chess_game'

describe ChessGame do
  describe '#game' do
    let(:board) { double('board') }
    let(:game) { ChessGame.new(board: board) }

    before do
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

    it 'switches players after looping' do
      allow(board).to receive(:checkmate?).and_return(false, true)
      allow(board).to receive(:return_all_valid_moves)
      allow(game).to receive(:player_turn)

      game.send(:game)
      expect(game.current_player).to eql(:black)
    end
  end

  describe '#select_move' do
    let(:board) { double('board') }
    let(:game) { ChessGame.new(board: board) }

    before do
      allow(board).to receive(:pretty_print)
      allow(board).to receive(:checked?).and_return(false)

      allow(game).to receive(:print)
    end

    context 'when user provides valid move' do
      it 'breaks out of loop and returns the move' do
        valid_moves = [[5, 2], [5, 3], [5, 4]]
        player_input = 'c5'
        allow(game).to receive(:gets).and_return(player_input)
        allow(game).to receive(:valid_coord?).and_return(true)
        allow(game).to receive(:chess_to_array_index).and_return([5, 2])

        move = game.send(:select_move, valid_moves)
        expect(move).to eql(valid_moves[0])
      end
    end

    context 'when user provides invalid move followed by a valid move' do
      it 'returns the error message one time' do
        valid_moves = [[5, 2], [5, 3], [5, 4]]
        allow(game).to receive(:gets).and_return('b5', 'c5')
        allow(game).to receive(:valid_coord?).and_return(true)
        allow(game).to receive(:chess_to_array_index).and_return([5, 1], [5, 2])

        expect(game).to receive(:puts).with('Invalid selection - Please select a valid move').once
        game.send(:select_move, valid_moves)
      end
    end

    context 'when user cancels move selection with empty response' do
      it 'breaks out of loop and returns nil' do
        valid_moves = []
        player_input = ''
        allow(game).to receive(:gets).and_return(player_input)
        allow(game).to receive(:valid_coord?).and_return(false)

        move = game.send(:select_move, valid_moves)
        expect(move).to eql(nil)
      end
    end
  end
end
