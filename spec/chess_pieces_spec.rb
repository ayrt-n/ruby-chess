# frozen_string_literal: true

require './lib/pieces/chess_piece'
require './lib/pieces/pawn'
require './lib/pieces/rook'
require './lib/pieces/bishop'
require './lib/pieces/knight'
require './lib/pieces/queen'
require './lib/pieces/king'

describe Pawn do
  describe '#valid_moves' do
    context 'when path not blocked and pawn has not moved' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(true)
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color)
        allow(board).to receive(:empty?).and_return(true)
        pawn = Pawn.new(color: 'W', curr_position: 19)

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to contain_exactly(3, 11)
      end
    end

    context 'when path is fully blocked' do
      it 'returns empty array' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(false)
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('W')
        pawn = Pawn.new(color: 'W', curr_position: 19)

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when path is partially blocked' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(true, false)
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('W')
        pawn = Pawn.new(color: 'W', curr_position: 19)

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to contain_exactly(11)
      end
    end

    context 'when path is not blocked but pawn has moved' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:empty?).and_return(true)
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color)
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
        allow(board).to receive(:in_bounds?).and_return(true)
        pawn = Pawn.new(color: 'W', curr_position: 19)

        valid_moves = pawn.valid_moves(board)

        expect(valid_moves).to contain_exactly(10, 12)
      end
    end
  end
end

describe Knight do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      knight = Knight.new(color: 'W', curr_position: 36)
      allow(knight).to receive(:move_valid?).and_return(true)

      valid_moves = knight.valid_moves(board)

      expect(valid_moves).to contain_exactly(19, 21, 26, 30, 42, 46, 51, 53)
    end

    context 'when there are no valid moves' do
      it 'returns empty array' do
        board = double('board')
        knight = Knight.new(color: 'W', curr_position: 36)
        allow(knight).to receive(:move_valid?).and_return(false)

        valid_moves = knight.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end
  end
end

describe Rook do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      rook = Rook.new(color: 'W', curr_position: 36)
      allow(rook).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false)
      allow(rook).to receive(:take?).and_return(false)

      valid_moves = rook.valid_moves(board)

      expect(valid_moves).to contain_exactly(28, 35, 37, 44)
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        rook = Rook.new(color: 'W', curr_position: 36)
        allow(rook).to receive(:move_valid?).and_return(false)

        valid_moves = rook.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when rook is blocked by enemy pieces' do
      it 'returns array of valid moves' do
        board = double('board')
        rook = Rook.new(color: 'W', curr_position: 36)
        allow(rook).to receive(:move_valid?).and_return(true)
        allow(rook).to receive(:take?).and_return(true)

        valid_moves = rook.valid_moves(board)

        expect(valid_moves).to contain_exactly(28, 35, 37, 44)
      end
    end
  end
end

describe Bishop do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      bishop = Bishop.new(color: 'W', curr_position: 36)
      allow(bishop).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false)
      allow(bishop).to receive(:take?).and_return(false)

      valid_moves = bishop.valid_moves(board)

      expect(valid_moves).to contain_exactly(27, 29, 43, 45)
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        bishop = Bishop.new(color: 'W', curr_position: 36)
        allow(bishop).to receive(:move_valid?).and_return(false)

        valid_moves = bishop.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when bishop is blocked by enemy pieces' do
      it 'returns array of valid moves' do
        board = double('board')
        bishop = Bishop.new(color: 'W', curr_position: 36)
        allow(bishop).to receive(:move_valid?).and_return(true)
        allow(bishop).to receive(:take?).and_return(true)

        valid_moves = bishop.valid_moves(board)

        expect(valid_moves).to contain_exactly(27, 29, 43, 45)
      end
    end
  end
end

describe Queen do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      queen = Queen.new(color: 'W', curr_position: 36)
      allow(queen).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false)
      allow(queen).to receive(:take?).and_return(false)

      valid_moves = queen.valid_moves(board)

      expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        queen = Queen.new(color: 'W', curr_position: 36)
        allow(queen).to receive(:move_valid?).and_return(false)

        valid_moves = queen.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when queen is blocked by enemy pieces' do
      it 'returns an array of valid moves' do
        board = double('board')
        queen = Queen.new(color: 'W', curr_position: 36)
        allow(queen).to receive(:move_valid?).and_return(true)
        allow(queen).to receive(:take?).and_return(true)

        valid_moves = queen.valid_moves(board)

        expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
      end
    end
  end
end

describe King do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      king = King.new(color: 'W', curr_position: 36)
      allow(king).to receive(:move_valid?).and_return(true)

      valid_moves = king.valid_moves(board)

      expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        king = King.new(color: 'W', curr_position: 36)
        allow(king).to receive(:move_valid?).and_return(false)

        valid_moves = king.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end
  end
end