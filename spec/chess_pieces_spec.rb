# frozen_string_literal: true

require './lib/chess_pieces'

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
    context 'when knight is not blocked by team' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:color)
        allow(board).to receive(:empty?).and_return(true)
        allow(board).to receive(:in_bounds?).and_return(true)
        knight = Knight.new(color: 'W', curr_position: 36)

        valid_moves = knight.valid_moves(board)

        expect(valid_moves).to contain_exactly(19, 21, 26, 30, 42, 46, 51, 53) 
      end
    end

    context 'when knight is fully blocked by team' do
      it 'returns empty array' do
        board = double('board')
        allow(board).to receive(:color).and_return('W')
        allow(board).to receive(:empty?).and_return(false)
        allow(board).to receive(:in_bounds?).and_return(true)
        knight = Knight.new(color: 'W', curr_position: 36)

        valid_moves = knight.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when one spot is blocked by team' do
      it 'returns array of size one less than full potential moveset (8)' do
        board = double('board')
        allow(board).to receive(:color).and_return('W', 'B', nil)
        allow(board).to receive(:empty?).and_return(false, true)
        allow(board).to receive(:in_bounds?).and_return(true)
        knight = Knight.new(color: 'W', curr_position: 36)

        valid_moves = knight.valid_moves(board)
        num_of_moves = valid_moves.size

        expect(num_of_moves).to eql(7)
      end
    end

    context 'when two moves are out of bounds of board' do
      it 'returns array of size two less than full potential moveset (8)' do
        board = double('board')
        allow(board).to receive(:color)
        allow(board).to receive(:empty?).and_return(true)
        allow(board).to receive(:in_bounds?).and_return(false, false, true)
        knight = Knight.new(color: 'W', curr_position: 12)

        valid_moves = knight.valid_moves(board)
        num_of_moves = valid_moves.size

        expect(num_of_moves).to eql(6)
      end
    end
  end
end

describe Rook do
  describe '#valid_moves' do
    context 'when rook is not blocked by any other pieces' do
      it 'returns an array of valid moves' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true, false, true, false, true, false, true, false)
        allow(board).to receive(:color)
        allow(board).to receive(:empty?).and_return(true)
        rook = Rook.new(color: 'W', curr_position: 36)

        valid_moves = rook.valid_moves(board)

        expect(valid_moves).to contain_exactly(28, 35, 37, 44)
      end
    end

    context 'when rook is fully blocked by team' do
      it 'returns an empty array' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('W')
        allow(board).to receive(:empty?).and_return(false)
        rook = Rook.new(color: 'W', curr_position: 36)

        valid_moves = rook.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when rook can take enemy pieces' do
      it 'returns an array of valid moves' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('B')
        allow(board).to receive(:empty?).and_return(false)
        rook = Rook.new(color: 'W', curr_position: 36)

        valid_moves = rook.valid_moves(board)

        expect(valid_moves).to contain_exactly(28, 35, 37, 44)
      end
    end
  end
end

describe Bishop do
  describe '#valid_moves' do
    context 'when bishop is not blocked by other pieces' do
      it 'returns array of valid moves' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true, false, true, false, true, false, true, false)
        allow(board).to receive(:color)
        allow(board).to receive(:empty?).and_return(true)
        bishop = Bishop.new(color: 'W', curr_position: 36)

        valid_moves = bishop.valid_moves(board)

        expect(valid_moves).to contain_exactly(27, 29, 43, 45)
      end
    end

    context 'when bishop is fully blocked by team' do
      it 'returns an empty array' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('W')
        allow(board).to receive(:empty?).and_return(false)
        bishop = Bishop.new(color: 'W', curr_position: 36)

        valid_moves = bishop.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when bishop can take enemy pieces' do
      it 'returns an array of valid moves' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('B')
        allow(board).to receive(:empty?).and_return(false)
        bishop = Bishop.new(color: 'W', curr_position: 36)

        valid_moves = bishop.valid_moves(board)

        expect(valid_moves).to contain_exactly(27, 29, 43, 45)
      end
    end
  end
end

describe Queen do
  describe '#valid_moves' do
    context 'when queen is not blocked by other pieces' do
      it 'returns an array of valid moves' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false)
        allow(board).to receive(:color)
        allow(board).to receive(:empty?).and_return(true)
        queen = Queen.new(color: 'W', curr_position: 36)

        valid_moves = queen.valid_moves(board)

        expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
      end
    end

    context 'when queen is fully blocked by team' do
      it 'returns an empty array' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('W')
        allow(board).to receive(:empty?).and_return(false)
        queen = Queen.new(color: 'W', curr_position: 36)

        valid_moves = queen.valid_moves(board)

        expect(valid_moves).to be_empty
      end
    end

    context 'when queen can take enemy pieces' do
      it 'returns an array of valid moves' do
        board = double('board')
        allow(board).to receive(:in_bounds?).and_return(true)
        allow(board).to receive(:color).and_return('B')
        allow(board).to receive(:empty?).and_return(false)
        queen = Queen.new(color: 'W', curr_position: 36)

        valid_moves = queen.valid_moves(board)

        expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
      end
    end
  end
end