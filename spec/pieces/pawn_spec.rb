# frozen_string_literal: true

require './lib/pieces/pawn'

describe Pawn do
  describe '#valid_moves' do
    context 'when pawn has not moved and cannot take' do
      it 'returns array of valid moves' do
        board = double('board')
        pawn = Pawn.new(:white)
        allow(pawn).to receive(:move_valid?).and_return(true)
        allow(pawn).to receive(:take?).and_return(false)
        allow(pawn).to receive(:left_en_passant?).and_return(false)
        allow(pawn).to receive(:right_en_passant?).and_return(false)
        current_position = [6, 3]

        valid_moves = pawn.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([5, 3], [4, 3])
      end
    end

    context 'when pawn has moved and cannot take' do
      it 'returns array of valid moves' do
        board = double('board')
        pawn = Pawn.new(:white)
        allow(pawn).to receive(:move_valid?).and_return(true)
        allow(pawn).to receive(:not_moved?).and_return(false)
        allow(pawn).to receive(:take?).and_return(false)
        allow(pawn).to receive(:left_en_passant?).and_return(false)
        allow(pawn).to receive(:right_en_passant?).and_return(false)
        current_position = [6, 3]

        valid_moves = pawn.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([5, 3])
      end
    end

    context 'when pawn has not moved and can take' do
      it 'returns array of valid moves' do
        board = double('board')
        pawn = Pawn.new(:white)
        allow(pawn).to receive(:move_valid?).and_return(true)
        allow(pawn).to receive(:take?).and_return(true)
        allow(pawn).to receive(:left_en_passant?).and_return(false)
        allow(pawn).to receive(:right_en_passant?).and_return(false)
        current_position = [6, 3]

        valid_moves = pawn.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([5, 3], [4, 3], [5, 2], [5, 4])
      end
    end

    context 'when pawn can take en passant' do
      it 'returns array of valid moves' do
        board = double('board')
        pawn = Pawn.new(:white, moved: true)
        allow(pawn).to receive(:move_valid?).and_return(false)
        allow(pawn).to receive(:take?).and_return(false)
        allow(pawn).to receive(:left_en_passant?).and_return(true)
        allow(pawn).to receive(:right_en_passant?).and_return(true)
        current_position = [6, 3]

        valid_moves = pawn.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([5, 2], [5, 4])
      end
    end

    context 'when no valid moves' do
      it 'returns array of valid moves' do
        board = double('board')
        pawn = Pawn.new(:white)
        allow(pawn).to receive(:move_valid?).and_return(false)
        allow(pawn).to receive(:take?).and_return(false)
        allow(pawn).to receive(:left_en_passant?).and_return(false)
        allow(pawn).to receive(:right_en_passant?).and_return(false)
        current_position = [6, 3]

        valid_moves = pawn.valid_moves(board, current_position)

        expect(valid_moves).to be_empty
      end
    end

    context 'when pawn is not white' do
      it 'returns array of valid moves' do
        board = double('board')
        pawn = Pawn.new(:black)
        allow(pawn).to receive(:move_valid?).and_return(true)
        allow(pawn).to receive(:take?).and_return(false)
        allow(pawn).to receive(:left_en_passant?).and_return(false)
        allow(pawn).to receive(:right_en_passant?).and_return(false)
        current_position = [1, 3]

        valid_moves = pawn.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([2, 3], [3, 3])
      end
    end
  end

  describe '#promotion?' do
    it 'returns true when pawn is at edge of board' do
      board = double('board')
      pawn = Pawn.new(:white)
      allow(board).to receive(:in_bounds?).and_return(false)
      current_position = [8, 2]

      expect(pawn.promotion?(board, current_position)).to eql(true)
    end

    it 'returns false when pawn is not at edge of board' do
      board = double('board')
      pawn = Pawn.new(:black)
      allow(board).to receive(:in_bounds?).and_return(true)
      current_position = [8, 2]

      expect(pawn.promotion?(board, current_position)).to eql(false) 
    end
  end
end
