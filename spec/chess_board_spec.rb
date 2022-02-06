# frozen_string_literal: true

require './lib/chess_board'

describe ChessBoard do
  describe '#move' do
    it 'moves object from one array location to another' do
      example_board = ChessBoard.new([[nil, 1, nil], [nil, nil, nil]])
      starting = [0, 1]
      ending = [1, 1]
      example_board.move(starting, ending)
      expect(example_board.board).to eql([[nil, nil, nil], [nil, 1, nil]])
    end
  end

  describe '#in_bounds?' do
    it 'returns true when position is in bounds of board' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).to be_in_bounds([0, 0])
    end

    it 'returns false when position is out of bounds of board' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).not_to be_in_bounds([0, 5])
    end

    it 'returns false when position is out of bounds of board' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).not_to be_in_bounds([-1, 0])
    end
  end

  describe '#empty?' do
    it 'returns true if spot is empty (nil)' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).to be_empty([1, 1])
    end

    it 'returns false if spot is not empty (nil)' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      expect(example_board).not_to be_empty([0, 0])
    end
  end
end