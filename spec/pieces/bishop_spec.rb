# frozen_string_literal: true

require './lib/pieces/chess_piece'
require './lib/pieces/bishop'

describe Bishop do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      bishop = Bishop.new(:white)
      allow(bishop).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false)
      allow(bishop).to receive(:take?).and_return(false)
      current_position = [4, 4]

      valid_moves = bishop.valid_moves(board, current_position)

      expect(valid_moves).to contain_exactly([3, 3], [3, 5], [5, 3], [5, 5])
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        bishop = Bishop.new(:white)
        allow(bishop).to receive(:move_valid?).and_return(false)
        current_position = [4, 4]

        valid_moves = bishop.valid_moves(board, current_position)

        expect(valid_moves).to be_empty
      end
    end

    context 'when bishop is blocked by enemy pieces' do
      it 'returns array of valid moves' do
        board = double('board')
        bishop = Bishop.new(:white)
        allow(bishop).to receive(:move_valid?).and_return(true)
        allow(bishop).to receive(:take?).and_return(true)
        current_position = [4, 4]

        valid_moves = bishop.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([3, 3], [3, 5], [5, 3], [5, 5])
      end
    end
  end
end
