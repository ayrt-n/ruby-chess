# frozen_string_literal: true

require './lib/pieces/chess_piece'
require './lib/pieces/pawn'
require './lib/pieces/rook'
require './lib/pieces/bishop'
require './lib/pieces/knight'
require './lib/pieces/queen'
require './lib/pieces/king'

describe ChessPiece do
  describe '#move' do
    it 'adds a move to the current position, returning the new position' do
      piece = ChessPiece.new(:white)
      current_position = [1, 1]
      move = [2, 2]
      new_position = piece.send(:move, current_position, move)
      
      expect(new_position).to eql([3, 3])
    end
  end
end

describe Bishop do
  describe '#valid_moves' do
    it 'returns array of valid moves' do
      board = double('board')
      bishop = Bishop.new(:white)
      allow(bishop).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false)
      allow(bishop).to receive(:take?).and_return(false)
      current_position = [4, 4]

      valid_moves = bishop.valid_moves(board, current_position)

      expect(valid_moves).to contain_exactly([3, 3], [3, 5], [5, 3], [5, 5])
    end

    context 'when there are no valid moves' do
      it 'returns an empty array' do
        board = double('board')
        bishop = Bishop.new(:white)
        allow(bishop).to receive(:move_valid?).and_return(false)
        current_position = [4, 4]

        valid_moves = bishop.valid_moves(board, current_position)

        expect(valid_moves).to be_empty
      end
    end

    context 'when bishop is blocked by enemy pieces' do
      it 'returns array of valid moves' do
        board = double('board')
        bishop = Bishop.new(:white)
        allow(bishop).to receive(:move_valid?).and_return(true)
        allow(bishop).to receive(:take?).and_return(true)
        current_position = [4, 4]

        valid_moves = bishop.valid_moves(board, current_position)

        expect(valid_moves).to contain_exactly([3, 3], [3, 5], [5, 3], [5, 5])
      end
    end
  end
end

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

# describe Pawn do
#   describe '#valid_moves' do
#     context 'when pawn has not moved and cannot take' do
#       it 'returns array of valid moves' do
#         board = double('board')
#         pawn = Pawn.new('W')
#         allow(pawn).to receive(:move_valid?).and_return(true)
#         allow(pawn).to receive(:take?).and_return(false)
#         current_position = 19

#         valid_moves = pawn.valid_moves(board, current_position)

#         expect(valid_moves).to contain_exactly(3, 11)
#       end
#     end

#     context 'when pawn has moved and cannot take' do
#       it 'returns array of valid moves' do
#         board = double('board')
#         pawn = Pawn.new('W')
#         allow(pawn).to receive(:move_valid?).and_return(true)
#         allow(pawn).to receive(:not_moved?).and_return(false)
#         allow(pawn).to receive(:take?).and_return(false)
#         current_position = 19

#         valid_moves = pawn.valid_moves(board, current_position)

#         expect(valid_moves).to contain_exactly(11)
#       end
#     end

#     context 'when pawn has not moved and can take' do
#       it 'returns array of valid moves' do
#         board = double('board')
#         pawn = Pawn.new('W')
#         allow(pawn).to receive(:move_valid?).and_return(true)
#         allow(pawn).to receive(:take?).and_return(true)
#         current_position = 19

#         valid_moves = pawn.valid_moves(board, current_position)

#         expect(valid_moves).to contain_exactly(3, 11, 10, 12)
#       end
#     end

#     context 'when no valid moves' do
#       it 'returns array of valid moves' do
#         board = double('board')
#         pawn = Pawn.new('W')
#         allow(pawn).to receive(:move_valid?).and_return(false)
#         allow(pawn).to receive(:take?).and_return(false)
#         current_position = 19

#         valid_moves = pawn.valid_moves(board, current_position)

#         expect(valid_moves).to be_empty
#       end
#     end
#   end
# end

# describe Rook do
#   describe '#valid_moves' do
#     it 'returns array of valid moves' do
#       board = double('board')
#       rook = Rook.new('W')
#       allow(rook).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false)
#       allow(rook).to receive(:take?).and_return(false)
#       current_position = 36

#       valid_moves = rook.valid_moves(board, current_position)

#       expect(valid_moves).to contain_exactly(28, 35, 37, 44)
#     end

#     context 'when there are no valid moves' do
#       it 'returns an empty array' do
#         board = double('board')
#         rook = Rook.new('W')
#         allow(rook).to receive(:move_valid?).and_return(false)
#         current_position = 36

#         valid_moves = rook.valid_moves(board, current_position)

#         expect(valid_moves).to be_empty
#       end
#     end

#     context 'when rook is blocked by enemy pieces' do
#       it 'returns array of valid moves' do
#         board = double('board')
#         rook = Rook.new('W')
#         allow(rook).to receive(:move_valid?).and_return(true)
#         allow(rook).to receive(:take?).and_return(true)
#         current_position = 36

#         valid_moves = rook.valid_moves(board, current_position)

#         expect(valid_moves).to contain_exactly(28, 35, 37, 44)
#       end
#     end
#   end
# end

# describe Queen do
#   describe '#valid_moves' do
#     it 'returns array of valid moves' do
#       board = double('board')
#       queen = Queen.new('W')
#       allow(queen).to receive(:move_valid?).and_return(true, false, true, false, true, false, true, false, true, false, true, false, true, false, true, false)
#       allow(queen).to receive(:take?).and_return(false)
#       current_position = 36

#       valid_moves = queen.valid_moves(board, current_position)

#       expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
#     end

#     context 'when there are no valid moves' do
#       it 'returns an empty array' do
#         board = double('board')
#         queen = Queen.new('W')
#         allow(queen).to receive(:move_valid?).and_return(false)
#         current_position = 36

#         valid_moves = queen.valid_moves(board, current_position)

#         expect(valid_moves).to be_empty
#       end
#     end

#     context 'when queen is blocked by enemy pieces' do
#       it 'returns an array of valid moves' do
#         board = double('board')
#         queen = Queen.new('W')
#         allow(queen).to receive(:move_valid?).and_return(true)
#         allow(queen).to receive(:take?).and_return(true)
#         current_position = 36

#         valid_moves = queen.valid_moves(board, current_position)

#         expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
#       end
#     end
#   end
# end

# describe King do
#   describe '#valid_moves' do
#     it 'returns array of valid moves' do
#       board = double('board')
#       king = King.new('W')
#       allow(king).to receive(:move_valid?).and_return(true)
#       current_position = 36

#       valid_moves = king.valid_moves(board, current_position)

#       expect(valid_moves).to contain_exactly(27, 28, 29, 35, 37, 43, 44, 45)
#     end

#     context 'when there are no valid moves' do
#       it 'returns an empty array' do
#         board = double('board')
#         king = King.new('W')
#         allow(king).to receive(:move_valid?).and_return(false)
#         current_position = 36

#         valid_moves = king.valid_moves(board, current_position)

#         expect(valid_moves).to be_empty
#       end
#     end
#   end
# end