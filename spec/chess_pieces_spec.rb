# frozen_string_literal: true

require './lib/chess_pieces'

describe Pawn do
  describe '#valid_moves' do
    context 'when path not blocked and pawn has not moved' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(true)
        pawn = Pawn.new(color: 'W', curr_position: 19)

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to contain_exactly(3, 11)
      end
    end

    context 'when path is fully blocked' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(false)
        pawn = Pawn.new(color: 'W', curr_position: 19)
        allow(board).to receive(:color).and_return('W')

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when path is partially blocked' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(true, false)
        pawn = Pawn.new(color: 'W', curr_position: 19)
        allow(board).to receive(:color).and_return('W')

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to contain_exactly(11)
      end
    end

    context 'when path is not blocked but pawn has moved' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(true)
        pawn = Pawn.new(color: 'W', curr_position: 19)
        allow(pawn).to receive(:moved).and_return(true)


        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to contain_exactly(11)
      end
    end

    context 'when pawn can take to the left/right diagonal' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(false)
        allow(board).to receive(:color).and_return('B')
        pawn = Pawn.new(color: 'W', curr_position: 19)

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to contain_exactly(10, 12)
      end
    end
  end
end