# frozen_string_literal: true

require './lib/pieces/knight'

describe Knight do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      knight = Knight.new(:white)
      allow(knight).to receive(:move_valid?).and_return(true)
      current_position = [4, 4]

      valid_moves = knight.valid_moves(board, current_position)

      expect(valid_moves).to contain_exactly([2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6,5])
    end

    context 'when there are no valid moves' do
      it 'returns empty array' do
        board = double('board')
        knight = Knight.new(:white)
        allow(knight).to receive(:move_valid?).and_return(false)
        current_position = [4, 4]

        valid_moves = knight.valid_moves(board, current_position)

        expect(valid_moves).to be_empty
      end
    end
  end
end
