# frozen_string_literal: true

require './lib/chess_board'

describe ChessBoard do
  describe '#move' do
    it 'moves object from one array location to another' do
      example_board = ChessBoard.new([1, nil, nil, nil, nil])
      example_board.move(0, 3)
      expect(example_board.board).to eql([nil, nil, nil, 1, nil])
    end
  end

  describe '#in_bounds?' do
    it 'returns true when position is in bounds of board' do
      example_board = ChessBoard.new([1, nil, nil, nil, nil])
      expect(example_board).to be_in_bounds(3)
    end

    it 'returns false when position is out of bounds of board' do
      example_board = ChessBoard.new([1, nil, nil, nil, nil])
      expect(example_board).not_to be_in_bounds(5)
    end
  end
end