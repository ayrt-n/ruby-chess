# frozen_string_literal: true

require './lib/pieces/king'

describe King do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      king = King.new(:white)
      allow(king).to receive(:move_valid?).and_return(true)
      current_position = [4, 4]

      valid_moves = king.valid_moves(board, current_position)

      expect(valid_moves).to contain_exactly([3, 4], [5, 4], [4, 3], [4, 5], [3, 3], [3, 5], [5, 3], [5, 5])
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        king = King.new(:white)
        allow(king).to receive(:move_valid?).and_return(false)
        current_position = [4, 4]

        valid_moves = king.valid_moves(board, current_position)

        expect(valid_moves).to be_empty
      end
    end
  end
end
