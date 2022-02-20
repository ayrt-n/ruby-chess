# frozen_string_literal: true

require './lib/chess_board'

describe ChessBoard do
  describe '#move_piece' do
    context 'when making a regular move' do
      it 'moves object from one array location to another' do
        piece = double('piece')
        example_board = ChessBoard.new([[nil, piece, nil], [nil, nil, nil]])
        starting = [0, 1]
        ending = [1, 1]

        example_board.send(:move_piece, starting, ending)
        expect(example_board.board).to eql([[nil, nil, nil], [nil, piece, nil]])
      end
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

  describe '#color' do
    it 'returns the color attribute from a piece' do
      piece = double('piece')
      allow(piece).to receive(:color).and_return(:black)
      example_board = ChessBoard.new([[nil, piece, nil], [nil, nil, nil]])

      color = example_board.color([0, 1])

      expect(color).to eql(:black)
    end

    it 'returns nil when position is empty' do
      piece = double('piece')
      allow(piece).to receive(:color).and_return(:black)
      example_board = ChessBoard.new([[nil, piece, nil], [nil, nil, nil]])

      color = example_board.color([0, 2])

      expect(color).to eql(nil)
    end
  end


  describe '#at_index' do
    it 'returns the element given board coordinates' do
      example_board = ChessBoard.new([[1, nil, nil], [nil, nil, nil]])
      board_element = example_board.at_index([0, 0])
      expect(board_element).to eql(1)
    end
  end

  describe '#king' do
    it 'returns the position of the king of a given color' do
      new_board = ChessBoard.new
      black_king = new_board.send(:king, :black)
      white_king = new_board.send(:king, :white)

      expect(black_king).to eql([0, 4])
      expect(white_king).to eql([7, 4])
    end
  end
end