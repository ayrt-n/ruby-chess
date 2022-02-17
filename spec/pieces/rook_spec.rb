# frozen_string_literal: true

require './lib/pieces/rook'

describe Rook do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      rook = Rook.new(:white)
      allow(rook).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false)
      allow(rook).to receive(:take?).and_return(false)
      current_position = [4, 4]

      valid_moves = rook.valid_moves(board, current_position)

      expect(valid_moves).to contain_exactly([3, 4], [5, 4], [4, 3], [4, 5])
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        rook = Rook.new(:white)
        allow(rook).to receive(:move_valid?).and_return(false)
        current_position = [4, 4]

        valid_moves = rook.valid_moves(board, current_position)

        expect(valid_moves).to be_empty
      end
    end

    context 'when rook is blocked by enemy pieces' do
      it 'returns array of valid moves' do
        board = double('board')
        rook = Rook.new(:white)
        allow(rook).to receive(:move_valid?).and_return(true)
        allow(rook).to receive(:take?).and_return(true)
        current_position = [4, 4]

        valid_moves = rook.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([3, 4], [5, 4], [4, 3], [4, 5])
      end
    end
  end
end
