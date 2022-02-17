# frozen_string_literal: true

require './lib/pieces/chess_piece'

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
