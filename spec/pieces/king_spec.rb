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

  describe '#castle_moves' do
    context 'when castle available on both sides' do
      it 'returns array of valid castling moves' do
        board = double('board')
        king = King.new(:white)
        allow(king).to receive(:valid_right_castle?).and_return(true)
        allow(king).to receive(:valid_left_castle?).and_return(true)
        current_position = [7, 4]

        valid_castle_moves = king.castle_moves(board, current_position)

        expect(valid_castle_moves).to contain_exactly([7, 6], [7, 2])
      end
    end

    context 'when castle is unavailable' do
      it 'returns an empty array' do
        board = double('board')
        king = King.new(:white)
        allow(king).to receive(:valid_right_castle?).and_return(false)
        allow(king).to receive(:valid_left_castle?).and_return(false)
        current_position = [7, 4]

        valid_castle_moves = king.castle_moves(board, current_position)

        expect(valid_castle_moves).to be_empty
      end
    end

    context 'when one castle is available' do
      it 'returns an array of valid castling moves' do
        board = double('board')
        king = King.new(:white)
        allow(king).to receive(:valid_right_castle?).and_return(true)
        allow(king).to receive(:valid_left_castle?).and_return(false)
        current_position = [7, 4]

        valid_castle_moves = king.castle_moves(board, current_position)

        expect(valid_castle_moves).to contain_exactly([7, 6])
      end
    end   
  end
end
